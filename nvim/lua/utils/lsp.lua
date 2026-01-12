local M = {}

--- Organizes imports and removes unused packages in the current buffer
-- @param timeout_ms number? The timeout in milliseconds (defaults to 1000)
function M.organize_imports(timeout_ms)
	local params = {
		textDocument = vim.lsp.util.make_text_document_params(),
		context = {
			only = { "source.organizeImports" },
		},
	}

	vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx)
		if err or not result then
			return
		end

		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local encoding = client and client.offset_encoding or "utf-16"

		for _, action in ipairs(result) do
			if action.edit then
				vim.lsp.util.apply_workspace_edit(action.edit, encoding)
			elseif action.command then
				vim.lsp.buf_request(0, "workspace/executeCommand", action.command, function(exec_err)
					if exec_err then
						vim.notify(exec_err.message, vim.log.levels.ERROR)
					end
				end)
			end
		end
	end)
end

return M
