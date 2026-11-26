-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap
local opt = { noremap = true, silent = true }

map.set({ "i" }, "kj", "<Esc>")

-- Alt + \ open terminal right bar
-- map.set({ "n", "i" }, "<A-\\>", "<Cmd>ToggleTerm size=50 direction=vertical<CR>", opt)
