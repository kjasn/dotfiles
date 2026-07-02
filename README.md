# MacOS Dotfiles

> [!WARNING]
>
> - 其他系统的 dotfiles 暂不维护，dot/MacOS 分支对于 Intel 芯片的 Mac 支持可能不太好

---

> [!WARNING]
>
> 开始之前请注意该配置具有一定侵入性，建议先阅读 `install.sh` 和 `uninstall.sh` 再执行。
>
> - 安装脚本会在 `$HOME` 和 `~/.config` 下创建多个符号链接，例如 Zsh、Tmux、Neovim、mise、
>   Kitty、Yazi、AeroSpace 等配置。
> - 如果目标路径已存在，脚本会按 `.bak.<timestamp>` 格式备份原文件或目录后再替换，但仍建议先手动确认重要配置已经备份。
> - 脚本会通过 Homebrew 安装或升级部分工具，并可能改动默认 shell、安装 Zim、
>   同步 LazyVim 插件、安装 Tmux 插件、执行 `mise install` 等操作。
> - 如果只想复用某个组件，建议不要直接运行完整安装脚本，而是复制对应目录或只执行相关配置的部署步骤。

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/kjasn/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 切换到对应系统的分支(Linux dotfiles 文件暂不维护)
git checkout dot/MacOS

# 运行安装脚本 脚本具有幂等性，可以多次执行
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
- **Aerospace**: 实现平铺式窗口管理，yabai 要关掉 SIP 才能使用，有点麻烦
- **Zsh + Zim**: 替换掉了 `oh-my-zsh`，据说更快一些，也有人推荐 `fish` 但是我懒得折腾了
- **PowerLevel10k**: 不喜欢 zim 官方文档的主题，所以换成了 PowerLevel10k
- **Tmux**: 好用，窗口多开（虽然通常终端都自带了，但是 tmux 可以搭配 `vim-navigator` 插件切换光标的位置），detach 后也能继续任务
- **Homebrew**: 必装
- **mise**: 管理 Go、Node、Python、Rust 等运行时依赖
- **Yazi**: TUI file manager，包含插件 `path-from-root`，便于复制文件路径，可选部署 `yazi/` 配置
- 终端模拟器：
  - `ghostty`，毛玻璃背景，光标修改为丰川祥子的代表色(#7799CC)，字体为`Monaco`和`Maple Mono NF CN`
  - `Kitty`: 可选配置文件 `shell/kitty/kitty.conf`、`shell/kitty/current-theme.conf`

---

## 📦 安装内容

### 自动安装

- Homebrew (如果未安装)
- Git, Zsh, Curl, Fzf, Ripgrep, fd
- mise，并可选安装 `mise/config.toml` 中声明的 Go、Node、Python
- 最新版 Neovim
- Zim Zsh 框架
- Tmux 插件管理器 (TPM)
- Aerospace 窗口管理器（可选）
- borders (AeroSpace 边框工具，可选)
- Kitty 配置（可选）
- Yazi 及其配置（可选）

---

## 🗂️ 目录结构

```bash
├── aerospace       # aerospace 配置
├── install.sh      # 安装脚本
├── uninstall.sh    # 卸载脚本
├── shell/          # shell 配置 (.zshrc, .zimrc，ghostty_config，kitty/)
├── mise/           # mise 运行时依赖配置
├── yazi/           # Yazi 文件管理器配置
├── nvim/           # LazyVim 配置
├── git/            # Git 配置
├── tmux/           # Tmux 配置
└── README.md       # 说明文档
```

## 🎯 配置简述

### Neovim (LazyVim)

- **LSP 支持**: Go、Python、Rust、TypeScript、React
- **格式化**: 自动代码格式化(半自动吧)
- **文件树**: MiniFiles 文件管理器
- **搜索**: fzf 模糊搜索

### Zsh (Zim)

- **智能补全**: fzf-tab 模糊补全
- **语法高亮**: 命令语法高亮
- **历史搜索**: 上下箭头搜索历史
- **自动建议**: 智能命令建议
- **快速跳转**：安装了 zoxide，可以通过 `z` 命令快速跳转
- **运行时管理**：通过 `mise activate zsh` 启用 mise

### mise

`mise/config.toml` 当前声明 Go、Node、Python、Rust。安装脚本会把它链接到 `~/.config/mise/config.toml`，
并询问是否执行 `mise install` 安装这些运行时依赖。

### Yazi

`yazi/` 当前包含 `package.toml` 和 `keymap.toml`，安装脚本可选将目录链接到 `~/.config/yazi`。
当前快捷键 `c r` 会调用 `path-from-root` 插件复制 Git 根目录相对路径。

### Tmux

本配置使用 `ctrl+q` 作为 `prefix` ，`prefix+h/j/k/l` 可以在不同的 pannel 之间跳转

## Aerospace

在默认配置的基础上，添加了一些自定义配置：

- 设置打开QQ，WeChat，Finder等应用时，窗口自动浮动并调整大小以适应内容
- 通过 JankyBorders 设置 active App 边框颜色
- 默认设置 ghostty 和 VS Code 放在 workspace S
- 禁用 Mac 默认的 `cmd+h`, `cmd-alt-h` 快捷键

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

设置 `XDG_CONFIG_HOME` 环境变量来指定配置文件位置

```shell
export XDG_CONFIG_HOME="$HOME/.config"
```

### Tmux 配置

由于使用 `oh-my-tmux` 配置，`./tmux/.tmux.conf`废弃，修改 tmux 配置请编辑 `./tmux/.tmux.conf.local`

```bash
# 示例：修改前缀键
set -g prefix C-b
```

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
