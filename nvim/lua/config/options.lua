-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.tabstop = 4 --  set tab as 4 spaces
opt.shiftwidth = 4 -- 4 spaces indent
opt.softtabstop = 4 -- delete 4 spaces each backspace
opt.expandtab = true -- tab show as spaces

-- 基本选项
-- vim.o.number = true
-- vim.o.relativenumber = true

-- 解决中文乱码
-- vim.o.encoding = "utf-8"
-- vim.o.fileencoding = "utf-8"
-- vim.o.termencoding = "utf-8"
