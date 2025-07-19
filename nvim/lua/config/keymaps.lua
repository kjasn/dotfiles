-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap
local opt = { noremap = true, silent = true }

map.set("n", "<leader>e", ":lua MiniFiles.open()<cr>", opt)

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

map.set({ "n", "i", "v" }, "<C-a>", "ggyG", opt)

map.set({ "n" }, "sv", ":vsp<CR>", opt)
map.set({ "n" }, "sh", ":sp<CR>", opt)

map.set({ "n", "i", "v" }, "<C-w>", ":bd<CR>", opt)

map.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", opt)
map.set("n", "<C-j>", ":TmuxNavigateDown<CR>", opt)
map.set("n", "<C-k>", ":TmuxNavigateUp<CR>", opt)
map.set("n", "<C-l>", ":TmuxNavigateRight<CR>", opt)

-- Mac 用户常用快捷键
-- Cmd + S 保存文件
map.set({ "n", "i", "v" }, "<D-s>", ":w<CR>", opt)

-- Cmd + Z 撤销
map.set({ "n", "i", "v" }, "<D-z>", "u", opt)

-- Cmd + Shift + Z 重做
map.set({ "n", "i", "v" }, "<D-Z>", "<C-r>", opt)

-- Cmd + C 复制
map.set({ "n", "i", "v" }, "<D-c>", '"+y', opt)

-- Cmd + V 粘贴
map.set({ "n", "i", "v" }, "<D-v>", '"+p', opt)

-- Cmd + X 剪切
map.set({ "n", "i", "v" }, "<D-x>", '"+d', opt)

-- Cmd + A 全选
map.set({ "n", "i", "v" }, "<D-a>", "ggVG", opt)

-- Cmd + F 查找
map.set({ "n", "i", "v" }, "<D-f>", "/", opt)

-- Cmd + R 替换
map.set({ "n", "i", "v" }, "<D-r>", ":%s/", opt)

-- Cmd + N 新建文件
map.set({ "n", "i", "v" }, "<D-n>", ":enew<CR>", opt)

-- Cmd + O 打开文件
map.set({ "n", "i", "v" }, "<D-o>", ":Telescope find_files<CR>", opt)

-- Cmd + W 关闭窗口/标签
map.set({ "n", "i", "v" }, "<D-w>", ":close<CR>", opt)

-- Cmd + Q 退出
map.set({ "n", "i", "v" }, "<D-q>", ":qa<CR>", opt)

-- Cmd + T 新建标签
map.set({ "n", "i", "v" }, "<D-t>", ":tabnew<CR>", opt)

-- Cmd + Shift + T 重新打开关闭的标签
map.set({ "n", "i", "v" }, "<D-T>", ":tabnew<CR>", opt)

-- Cmd + 数字键 切换到对应标签
for i = 1, 9 do
    map.set({ "n", "i", "v" }, "<D-" .. i .. ">", ":" .. i .. "tabnext<CR>", opt)
end

-- Cmd + 0 切换到最后一个标签
map.set({ "n", "i", "v" }, "<D-0>", ":tablast<CR>", opt)
