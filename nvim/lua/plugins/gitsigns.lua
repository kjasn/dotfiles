return {
	"lewis6991/gitsigns.nvim",
	init = function()
		local function staged_file_color()
			vim.api.nvim_set_hl(0, "GitSignsDiffStaged", { link = "GitSignsAdd" })
		end
		local saved_timeoutlen
		local function enter_diff_panel()
			if vim.bo.filetype == "gitsigns-diff" and not saved_timeoutlen then
				-- Space is also leader, so its panel mapping still waits for timeoutlen.
				saved_timeoutlen = vim.o.timeoutlen
				vim.o.timeoutlen = 150
			end
		end
		local function leave_diff_panel()
			if vim.bo.filetype == "gitsigns-diff" and saved_timeoutlen then
				vim.o.timeoutlen = saved_timeoutlen
				saved_timeoutlen = nil
			end
		end

		staged_file_color()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = staged_file_color })
		vim.api.nvim_create_autocmd("WinEnter", { callback = enter_diff_panel })
		vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, { callback = leave_diff_panel })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "gitsigns-diff",
			callback = function(args)
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(args.buf) then
						return
					end
					for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(args.buf, "n")) do
						if
							(mapping.lhs == "s" and mapping.desc == "Stage file or directory")
							or (mapping.lhs == "u" and mapping.desc == "Unstage file or directory")
						then
							vim.keymap.del("n", mapping.lhs, { buffer = args.buf })
						elseif mapping.lhs == " " and mapping.desc == "Toggle file or directory staging" then
							vim.keymap.set("n", "<Space>", mapping.callback, {
								buffer = args.buf,
								desc = mapping.desc,
								nowait = true,
							})
						end
					end
					enter_diff_panel()
				end)
			end,
		})
	end,
	opts = {
		current_line_blame = true,
	},
}
