# MacOS Dotfiles

> 一键安装 & 管理 MacOS 环境下的开发配置（Zsh / Neovim / Git / Tmux / Homebrew）
>
> 专为 Mac 用户优化，支持 Apple Silicon 和 Intel 芯片。

---

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/kjasn/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 切换到 MacOS 分支
git checkout refactor/mac-dotfiles

# 运行安装脚本
bash install.sh
```

---

## ✨ 功能特性

### 🛠️ 开发环境

-   **Neovim + LazyVim**: 现代化编辑器配置，支持 LSP、语法检查、格式化
-   **Zsh + Zim**: 快速、模块化的 Zsh 框架
-   **Tmux**: 终端复用器，支持会话管理
-   **Homebrew**: MacOS 包管理器

### 🎨 用户体验

-   **Maple Mono NF CN 字体**: 编程专用等宽字体，支持图标
-   **Mac 快捷键**: Cmd+S 保存、Cmd+C/V 复制粘贴等
-   **智能补全**: zoxide 智能目录跳转
-   **语法高亮**: 代码语法高亮和自动补全

### 🔧 开发工具

-   **Git 配置**: 优化的 Git 别名和配置
-   **Node.js**: 可选 nvm 安装
-   **Go**: Go 语言环境配置
-   **Python**: Conda 环境支持

---

## 📦 安装内容

### 自动安装

-   Homebrew (如果未安装)
-   Git, Zsh, Curl, Fzf, Ripgrep, fd
-   最新版 Neovim
-   Zim Zsh 框架
-   Maple Mono NF CN 字体
-   Tmux 插件管理器 (TPM)

### 可选安装

-   nvm (Node Version Manager)

### 实用脚本

-   **git-sync.sh**: Git 上游同步脚本，用于同步 fork 仓库的上游更新
    -   使用方法: `./scripts/git-sync.sh [master|main]`
    -   如需全局使用，可复制到 `/usr/local/bin/` 目录

---

## 🗂️ 目录结构

```
├── install.sh      # MacOS 安装脚本
├── uninstall.sh    # 卸载脚本
├── shell/          # Zsh 配置 (.zshrc, .zimrc)
├── nvim/           # LazyVim 配置
├── git/            # Git 配置
├── tmux/           # Tmux 配置
├── scripts/        # 实用脚本
│   └── git-sync.sh # Git 上游同步脚本
└── README.md       # 说明文档
```

---

## 🎯 配置亮点

### Neovim (LazyVim)

-   **Mac 快捷键**: Cmd+S 保存、Cmd+C/V 复制粘贴
-   **LSP 支持**: Go、Python、TypeScript、React
-   **格式化**: 自动代码格式化
-   **文件树**: MiniFiles 文件管理器
-   **搜索**: Telescope 模糊搜索

### Zsh (Zim)

-   **智能补全**: fzf-tab 模糊补全
-   **语法高亮**: 命令语法高亮
-   **历史搜索**: 上下箭头搜索历史
-   **自动建议**: 智能命令建议

### Tmux

-   **会话管理**: 持久化会话
-   **窗口分割**: 水平/垂直分割
-   **插件支持**: 主题、状态栏插件

---

## 🔄 卸载

```bash
bash uninstall.sh
```

卸载脚本将：

-   恢复备份的配置文件
-   删除符号链接
-   卸载字体
-   清理缓存
-   可选卸载 Homebrew 包

---

## 🎨 字体设置

安装完成后，请在终端应用中设置字体为 **Maple Mono NF CN**：

1. 打开终端应用设置
2. 找到字体设置
3. 选择 "Maple Mono NF CN"
4. 建议字号：12-14

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

编辑 `tmux/.tmux.conf` 修改 Tmux 行为：

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

---

## 🐛 故障排除

### 字体不显示

```bash
# 检查字体是否安装
fc-list | grep "Maple Mono NF CN"

# 重新安装字体
bash install.sh
```

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

---

## 📝 更新日志

-   **v1.0.0**: 初始 MacOS 版本
    -   支持 Apple Silicon 和 Intel Mac
    -   集成 Homebrew 包管理
    -   添加 Maple Mono NF CN 字体
    -   优化 Mac 用户快捷键
