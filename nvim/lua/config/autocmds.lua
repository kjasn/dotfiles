-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup("UserAutoCmds", { clear = true })

-- Auto save when buffer is hidden (like VSCode onFocusChange)
vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	pattern = "*",
	nested = true,
	callback = function()
		if vim.bo.modified then
			vim.cmd("silent! update")
		end
	end,
	desc = "Auto save on buffer leave",
})

-- Fallback: auto save on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
	group = augroup,
	pattern = "*",
	nested = true,
	callback = function()
		if vim.bo.modified then
			vim.cmd("silent! update")
		end
	end,
	desc = "Auto save on focus lost",
})

-- Auto organize imports on save for various file types (excluding Go, handled by gopls)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = { "*.py", "*.ts", "*.tsx", "*.js", "*.jsx" },
	callback = function()
		pcall(function()
			local lsp_utils = require("utils.lsp")
			lsp_utils.organize_imports(1000)
		end)
	end,
	desc = "Organize imports on save",
})
