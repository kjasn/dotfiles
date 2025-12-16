# MacOS Dotfiles

> [!WARNING]
>
> - 其他系统的 dotfiles 暂不维护，dot/MacOS 分支对于 Intel 芯片的 Mac 支持可能不太好

---

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/kjasn/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 切换到对应系统的分支(Linux dotfiles 文件暂不维护)
git checkout dot/MacOS

# 运行安装脚本
chmod +x ./install.sh
./install.sh
```

**安装后设置**：

1. 重新启动终端应用
2. 根据 PowerLevel10k 配置提示设置终端样式
3. 如需重新配置：`p10k configure`

---

## ✨ 功能特性

### 🛠️ 开发环境

- **Neovim + LazyVim**
- **Zsh + Zim**: 替换掉了 `oh-my-zsh`，据说更快一些，也有人推荐 `fish` 但是我懒得折腾了
- **PowerLevel10k**: 不喜欢 zim 官方文档的主题，所以换成了 PowerLevel10k
- **Tmux**: 好用，窗口多开（虽然通常终端都自带了，但是 tmux 可以搭配 `vim-navigator` 插件切换光标的位置），detach 后也能继续任务
- **Homebrew**: 必装

---

## 📦 安装内容

### 自动安装

- Homebrew (如果未安装)
- Git, Zsh, Curl, Fzf, Ripgrep, fd
- 最新版 Neovim
- Zim Zsh 框架
- Tmux 插件管理器 (TPM)

### 实用脚本

- **git-sync.sh**: Git 上游同步脚本，用于同步 fork 仓库的上游更新
  - 使用方法: `./scripts/git-sync.sh [master|main]`
  - 如需全局使用，可复制到 `/usr/local/bin/` 目录
- **upload-file-to-server.sh**: 服务器文件上传脚本，使用固定 SSH 密钥快速上传文件
  - 使用方法: `./scripts/upload-file-to-server.sh <本地路径> <远程路径>`
  - 使用前需要配置脚本中的服务器信息和 SSH 密钥路径

---

## 🗂️ 目录结构

```bash
├── install.sh      # 安装脚本
├── uninstall.sh    # 卸载脚本
├── shell/          # shell 配置 (.zshrc, .zimrc，ghostty_config)
├── nvim/           # LazyVim 配置
├── git/            # Git 配置
├── tmux/           # Tmux 配置
├── scripts/        # 实用脚本
│   ├── git-sync.sh # Git 上游同步脚本
│   └── upload-stage-server.sh # 服务器文件上传脚本
└── README.md       # 说明文档
```

---

## 🎯 配置简述

### Neovim (LazyVim)

- **LSP 支持**: Go、Python、TypeScript、React
- **格式化**: 自动代码格式化(半自动吧)
- **文件树**: MiniFiles 文件管理器
- **搜索**: fzf 模糊搜索

### Zsh (Zim)

- **智能补全**: fzf-tab 模糊补全
- **语法高亮**: 命令语法高亮
- **历史搜索**: 上下箭头搜索历史
- **自动建议**: 智能命令建议
- **快速跳转**：安装了 zoxide，可以通过 `z` 命令快速跳转

### Tmux

本配置使用 `ctrl+q` 作为 `prefix` ，`prefix+h/j/k/l` 可以在不同的 pannel 之间跳转

---

## 🔄 卸载

```bash
chmod +x ./uninstall.sh
./uninstall.sh
```

卸载脚本将：

- 恢复备份的配置文件
- 删除符号链接
- 卸载字体
- 清理缓存
- 可选卸载 Homebrew 包

---

## 🔧 自定义

### Neovim 快捷键

编辑 `nvim/lua/config/keymaps.lua` 添加自定义快捷键：

```lua
-- 示例：添加新的快捷键
map.set("n", "<leader>ff", ":Telescope find_files<CR>", opt)
```

### Zsh 配置

编辑 `shell/.zshrc` 添加环境变量或别名：

```bash
# 示例：添加别名
alias ll="ls -la"
```

### Tmux 配置

由于使用 `oh-my-tmux` 配置，`./tmux/.tmux.conf`废弃，修改 tmux 配置请编辑 `./tmux/.tmux.conf.local`

```bash
# 示例：修改前缀键
set -g prefix C-b
```

## 📜 脚本使用

### git-sync.sh

用于同步 fork 仓库的上游更新：

```bash
# 在 dotfiles 目录中使用
./scripts/git-sync.sh main

# 如需全局使用，复制到系统路径
sudo cp scripts/git-sync.sh /usr/local/bin/git-sync
sudo chmod +x /usr/local/bin/git-sync

# 然后在任何 Git 仓库中使用
git-sync main
```

**使用前准备**：

1. 确保已配置 upstream 远程仓库：`git remote add upstream <原仓库URL>`
2. 脚本会自动备份当前分支状态
3. 支持 master 和 main 分支

### upload-stage-server.sh

用于快速上传文件到远程服务器：

```bash
# 在 dotfiles 目录中使用
./scripts/upload-stage-server.sh ./my_project /var/www/html/

# 如需全局使用，复制到系统路径
sudo cp scripts/upload-stage-server.sh /usr/local/bin/upload-stage-server
sudo chmod +x /usr/local/bin/upload-stage-server

# 然后在任何地方使用
upload-stage-server ./my_project /var/www/html/
```

**使用前准备**：

1. 编辑脚本配置服务器信息：`REMOTE_USER`、`REMOTE_HOST`、`REMOTE_PORT`
2. 配置 SSH 密钥路径：`SSH_KEY_PATH`
3. 确保 SSH 密钥有访问服务器的权限
4. 脚本会自动检查远程文件是否存在，避免意外覆盖

## PowerLevel10k 主题配置

### 配置向导

执行 `p10k configure` 进行配置，要修改配置就重新执行一次。
配置文件位置：`~/.p10k.zsh`

---

### Homebrew 路径问题

```bash
# Apple Silicon Mac
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Mac
eval "$(/usr/local/bin/brew shellenv)"
```

### Neovim 插件问题

```bash
# 重新同步插件
nvim --headless "+Lazy! sync" +qa
```
