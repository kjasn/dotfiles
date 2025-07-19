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

-- 启用显示匹配括号
opt.showmatch = true

-- 启用显示模式
opt.showmode = true

-- 启用显示命令
opt.showcmd = true

-- 启用显示行尾空格
opt.list = true
opt.listchars = { tab = "→ ", trail = "·" }

-- 启用自动换行
opt.wrap = true

-- 启用断行
opt.linebreak = true

-- 启用显示空白字符
opt.list = true

-- 启用显示行号
opt.number = true

-- 启用显示相对行号
opt.relativenumber = true

-- 启用显示光标位置
opt.ruler = true

-- 启用显示状态行
opt.laststatus = 2

-- 启用显示标签页
opt.showtabline = 2

-- 启用显示菜单
opt.wildmenu = true

-- 启用显示补全菜单
opt.completeopt = "menu,menuone,noselect"

-- 启用显示预览窗口
opt.previewheight = 10

-- 启用显示分割窗口
opt.splitbelow = true
opt.splitright = true

-- 启用显示隐藏字符
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- 启用显示行尾
opt.eol = false

-- 启用显示文件类型
opt.filetype = "on"

-- 启用显示语法高亮
opt.syntax = "on"

-- 启用显示颜色
opt.termguicolors = true

-- 启用显示背景
opt.background = "dark"

-- 启用显示字体
opt.guifont = "Maple Mono NF CN:h12"

-- 启用显示图标
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.termencoding = "utf-8"

-- 启用显示时间
opt.timeout = true
opt.timeoutlen = 300

-- 启用显示历史
opt.history = 1000

-- 启用显示撤销
opt.undofile = true
opt.undodir = vim.fn.expand("~/.cache/nvim/undo")

-- 启用显示备份
opt.backup = false
opt.writebackup = false

-- 启用显示交换文件
opt.swapfile = false

-- 启用显示临时文件
opt.tmpdir = vim.fn.expand("~/.cache/nvim/tmp")

-- 启用显示会话
opt.sessionoptions = "blank,buffers,curdir,folds,help,options,tabpages,winsize"

-- 启用显示窗口
opt.winminheight = 0
opt.winminwidth = 0

-- 启用显示缓冲区
opt.hidden = true

-- 启用显示自动命令
opt.autoread = true
opt.autowrite = true

-- 启用显示补全
opt.complete = ".,w,b,u,t,i"

-- 启用显示标签
opt.tags = "./tags,tags"

-- 启用显示路径
opt.path = ".,/usr/include,,"
