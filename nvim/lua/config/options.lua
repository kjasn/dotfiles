-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- 缩进配置 (LazyVim 默认是 2)
opt.tabstop = 4 -- Tab 占 4 个空格
opt.shiftwidth = 4 -- 缩进使用 4 个空格
opt.softtabstop = 4 -- 退格键删除 4 个空格
opt.expandtab = true -- 将 Tab 转换为垂直空格

-- 文本显示
opt.wrap = true -- 启用自动换行
opt.linebreak = true -- 不在单词中间断行

-- Keep folds open by default; let LazyVim choose the guarded foldexpr.
opt.foldlevel = 99
opt.foldtext = ""
opt.foldcolumn = "0"
opt.foldlevelstart = 99

opt.laststatus = 3

-- Reduce LSP log verbosity to avoid huge logs
vim.lsp.set_log_level("WARN")
