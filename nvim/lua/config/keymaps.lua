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

--qwen-mt-plus live_grep_args
-- map.set("n", "<leader>/", "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Live Grep (fzf)" })

-- map.set({ "n", "i", "v" }, "<C-w>", "<leader>bd<CR>", opt)

-- map.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", opt)
-- map.set("n", "<C-j>", ":TmuxNavigateDown<CR>", opt)
-- map.set("n", "<C-k>", ":TmuxNavigateUp<CR>", opt)
-- map.set("n", "<C-l>", ":TmuxNavigateRight<CR>", opt)
