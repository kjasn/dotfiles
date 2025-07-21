# dotfiles

> 一键安装 & 管理本人在 WSL(Ubuntu-24.04) 环境下常用的开发配置（Zsh / Neovim / Git / Tmux …）。
>
> 其他 Linux 发行版亦可尝试，请切换到对应分支。

---

## 目录结构

```
├── install.sh      # 主安装脚本（可重复执行，具备幂等性）
├── uninstall.sh    # 卸载脚本（还原符号链接 / 可选）
├── shell/          # Zsh 相关配置（.zshrc 等）
├── nvim/           # LazyVim 配置（init.lua / lua/*）
├── git/            # Git 配置与脚本（git-sync.sh）
├── tmux/           # Tmux 配置（.tmux.conf）
└── …
```

## 功能速览

1. **符号链接管理**：将 dotfiles 软链到 `$HOME`，原文件自动备份并带时间戳。
2. **基础依赖安装**：Git / Zsh / Curl / Fzf / Build-Essential / Ripgrep / fd 等。
3. **最新版 Neovim**：官方二进制安装至 `/opt/nvim` 并软链到 `/usr/local/bin`。
4. **Zim 框架**：自动写入 `/etc/shells` 并切换默认 Shell。
5. **LazyVim**：`nvim --headless "+Lazy! sync"` 同步全部插件。
6. **可选 nvm**：安装前询问是否需要 Node Version Manager。
7. **彩色输出 & 错误检测**：步骤清晰、出错即停 (`set -e`)。

---

## 一键安装

```bash
# 克隆仓库（或自行置于 ~/dotfiles）
git clone https://github.com/kjasn/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 运行安装脚本
bash install.sh
```

执行过程中脚本将：

1. `sudo apt update` 安装依赖包；
2. 若系统未装 Neovim，自动下载最新版本并解压；
3. 询问 **是否安装 nvm**（y/N）；
4. 创建所有符号链接；
5. 安装 Zim & 切换默认 Shell；
6. 同步 LazyVim 插件；

脚本具备**幂等性**，可在更新 dotfiles 后 **重复执行** 以刷新符号链接或升级依赖。

---

## 卸载

```bash
bash uninstall.sh
```

脚本将尝试删除软链并恢复备份文件；对于自行安装的软件（Neovim、Zim 等）请按需手动移除。

---

## 自定义

### Lazyvim

默认使用系统剪贴板，`yy`，`dd`等行为都会复制内容到系统剪切板（打开系统剪贴板可能看不到复制的内容），`p` 会粘贴到光标所在位置，此功能依赖 `xclip` 工具，脚本默认安装，如果不需要，在 `nvim/lua/config/options.lua` 中注释掉以下配置

```lua
vim.opt.clipboard = "unnamedplus"
```

### Tmux

默认使用 ctrl+a 作为前缀，如果不需要，在 `tmux/.tmux.conf` 中注释掉以下配置

```bash
set -g prefix C-a
```

### Script

该目录下为一些可选的脚本。将其放到 `/usr/local/bin` 或 `~/.local/bin` 下，并赋予执行权限即可全局使用。

## TODO

-   [ ] MacOS 分支完善
-   [x] 字体与美化脚本
-   [x] 自动安装 LSP / DAP / Mason Packages

---
