-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup("UserAutoCmds", { clear = true })

-- Auto save all modified buffers on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
	group = augroup,
	pattern = "*",
	nested = true, -- Allow nested autocmds to run
	callback = function()
		if vim.bo.modified and vim.fn.filereadable(vim.fn.expand("%")) then
			vim.cmd("silent! wall")
		end
	end,
	desc = "Auto save all modified buffers on focus lost",
})