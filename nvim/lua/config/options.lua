-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
opt.tabstop = 4 --  set tab as 4 spaces
opt.shiftwidth = 4 -- 4 spaces indent
opt.softtabstop = 4 -- delete 4 spaces each backspace
opt.expandtab = true -- tab show as spaces
opt.wrap = true
opt.linebreak = true

-- set clipboard system clipboard
vim.opt.clipboard = "unnamedplus"

-- MacOS 特定配置
-- 启用鼠标支持
opt.mouse = "a"

-- 启用系统剪贴板
opt.clipboard:append("unnamedplus")

-- 启用光标行高亮
opt.cursorline = true

-- 启用光标列高亮
opt.cursorcolumn = false

-- 启用行号
opt.number = true

-- 启用相对行号
opt.relativenumber = true

-- 启用符号列
opt.signcolumn = "yes"

-- 启用搜索高亮
opt.hlsearch = true

-- 启用增量搜索
opt.incsearch = true

-- 启用忽略大小写搜索
opt.ignorecase = true

-- 启用智能大小写搜索
opt.smartcase = true

-- 启用自动缩进
opt.autoindent = true

-- 启用智能缩进
opt.smartindent = true
