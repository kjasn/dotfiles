local M = {}

local status_groups = { "conflicts", "unstaged", "staged" }

local function supports_directory_tree(files)
	local paths = {}
	for _, file in ipairs(files) do
		local path = file.path:gsub("/$", "")
		if paths[path] then
			return false
		end
		paths[path] = true
	end
	for path in pairs(paths) do
		for parent in vim.fs.parents(path) do
			if paths[parent] then
				return false
			end
		end
	end
	return true
end

function M.setup_explorer()
	local options = require("codediff.config").options.explorer
	local tree = require("codediff.ui.explorer.tree")
	local nodes = require("codediff.ui.explorer.nodes")
	local filter = require("codediff.ui.explorer.filter")
	local lifecycle = require("codediff.ui.lifecycle")
	local git = require("codediff.core.git")
	local refresh = require("codediff.ui.refresh")

	local create_tree_data = tree.create_tree_data
	local get_all_files = tree.get_all_files
	local prepare_node = nodes.prepare_node
	local format_file = options.formatters.file or require("codediff.ui.explorer.formatters").file
	local rendering_file

	options.formatters.file = function(ctx)
		if rendering_file and rendering_file.show_directory then
			ctx.directory = ctx.path:sub(1, -(#ctx.filename + 1))
		end
		local row = format_file(ctx)
		if rendering_file and rendering_file.fully_staged then
			row.left[2].segments[1].hl = "CodeDiffStatusAdded"
		end
		return row
	end

	-- Keep the original group on each file for Git actions and diff selection.
	function tree.create_tree_data(status, git_root, base_revision, is_dir_mode, visible_groups)
		if is_dir_mode or base_revision then
			return create_tree_data(status, git_root, base_revision, is_dir_mode, visible_groups)
		end

		local visible = visible_groups or options.visible_groups
		local files, groups, pending = {}, {}, {}
		for _, group in ipairs(status_groups) do
			local candidates = filter.apply(status[group] or {}, options.file_filter.ignore)
			candidates = nodes.filter_merge_artifacts(candidates)
			for _, file in ipairs(candidates) do
				if group ~= "staged" then
					pending[file.path] = true
				end
				if visible[group] ~= false and not groups[file.path] then
					files[#files + 1] = file
					groups[file.path] = group
				end
			end
		end

		local tree_mode = options.view_mode == "tree"
		-- A Git change can replace a file with a directory of the same name.
		local show_tree = tree_mode and supports_directory_tree(files)
		local roots
		if show_tree then
			roots = nodes.create_tree_file_nodes(files, git_root)
		else
			table.sort(files, function(a, b)
				return a.path < b.path
			end)
			roots = nodes.create_file_nodes(files, git_root)
		end

		local function assign_groups(node)
			local data = node.data
			if data.type == "directory" then
				data.path = data.dir_path
				local group = "staged"
				for _, child in ipairs(node._children) do
					local child_group = assign_groups(child)
					if child_group == "conflicts" or group == "staged" then
						group = child_group
					end
				end
				data.group = group
				node:expand()
			else
				data.group = groups[data.path]
				data.merged_status = true
				data.fully_staged = data.group == "staged" and not pending[data.path]
				data.show_directory = tree_mode and not show_tree
			end
			return data.group
		end
		for _, root in ipairs(roots) do
			assign_groups(root)
		end
		return roots
	end

	function tree.get_all_files(explorer_tree)
		local roots = explorer_tree:get_nodes()
		if not roots[1] or roots[1].data.type == "group" then
			return get_all_files(explorer_tree)
		end

		-- gS can select the staged diff for a row that still represents unstaged changes.
		local explorer = lifecycle.get_panel_view(vim.api.nvim_get_current_tabpage())
		local selection = explorer and explorer.tree == explorer_tree and explorer.data.current_selection
		local files = {}
		local function collect(node)
			local data = node.data
			if data.type == "directory" then
				if node:is_expanded() then
					for _, child in ipairs(node._children) do
						collect(child)
					end
				end
			else
				local file = selection and selection.path == data.path and selection or data
				files[#files + 1] = { node = node, data = file }
			end
		end
		for _, root in ipairs(roots) do
			collect(root)
		end
		return files
	end

	function nodes.prepare_node(node, width, selected_path, selected_group)
		local data = node.data
		if not data.merged_status then
			return prepare_node(node, width, selected_path, selected_group)
		end
		if data.path == selected_path then
			selected_group = data.group
		end
		-- CodeDiff's formatter context does not include custom node data.
		local previous = rendering_file
		rendering_file = data
		local ok, row = pcall(prepare_node, node, width, selected_path, selected_group)
		rendering_file = previous
		if not ok then
			error(row, 0)
		end
		return row
	end

	-- Recheck the status after the index write, even if the watcher fires early.
	for _, name in ipairs({ "stage_file", "unstage_file" }) do
		local update_index = git[name]
		git[name] = function(git_root, path, callback)
			local tabpage = vim.api.nvim_get_current_tabpage()
			local explorer = lifecycle.get_panel_view(tabpage)
			return update_index(git_root, path, function(err)
				callback(err)
				if not err and options.auto_refresh and explorer and explorer.data.git_root == git_root then
					vim.schedule(function()
						if lifecycle.get_panel_view(tabpage) == explorer then
							refresh.request(tabpage, { index = true })
						end
					end)
				end
			end)
		end
	end
end

return M
