-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap
local opt = { noremap = true, silent = true }

map.set({ "i" }, "kj", "<Esc>")

-- Alt + ` open terminal at buttom
-- map.set({ "n", "i" }, "<A-`>", "<Cmd>ToggleTerm<CR>", opt)

-- Alt + \ open terminal right bar
-- map.set({ "n", "i" }, "<A-\\>", "<Cmd>ToggleTerm size=50 direction=vertical<CR>", opt)

-- live_grep_args
map.set(
	"n",
	"<leader>/",
	":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
	{ desc = "Live Grep With Args" }
)

map.set({ "n", "i", "v" }, "<C-w>", ":bd<CR>", opt)

-- map.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", opt)
-- map.set("n", "<C-j>", ":TmuxNavigateDown<CR>", opt)
-- map.set("n", "<C-k>", ":TmuxNavigateUp<CR>", opt)
-- map.set("n", "<C-l>", ":TmuxNavigateRight<CR>", opt)
