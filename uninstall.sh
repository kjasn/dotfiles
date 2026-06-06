#!/bin/bash

set -e # 遇到错误立即退出

# 彩色输出定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "\n${GREEN}=== 开始卸载 MacOS dotfiles ===${NC}"

# 检查操作系统
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}错误：此脚本仅适用于 MacOS${NC}"
    exit 1
fi

# 恢复备份文件
restore_backups() {
    echo -e "\n${GREEN}=== 恢复备份文件 ===${NC}"

    # 查找并恢复备份文件
    for backup_file in ~/.zshrc.bak.* ~/.gitconfig.bak.* ~/.tmux.conf.bak.* ~/.config/nvim.bak.* ~/.config/aerospace/aerospace.toml.bak.* ~/.config/ghostty/config.bak.* ~/.config/kitty/kitty.conf.bak.* ~/.config/kitty/current-theme.conf.bak.* ~/.config/mise/config.toml.bak.* ~/.config/yazi.bak.*; do
        if [ -e "$backup_file" ]; then
            original_file="${backup_file%.bak.*}"
            echo -e "${YELLOW}恢复备份: $backup_file -> $original_file${NC}"
            mv "$backup_file" "$original_file"
        fi
    done
}

# 删除符号链接
remove_symlinks() {
    echo -e "\n${GREEN}=== 删除符号链接 ===${NC}"

    # 删除符号链接
    if [ -L ~/.zshrc ]; then
        echo -e "${YELLOW}删除符号链接: ~/.zshrc${NC}"
        rm ~/.zshrc
    fi

    if [ -L ~/.gitconfig ]; then
        echo -e "${YELLOW}删除符号链接: ~/.gitconfig${NC}"
        rm ~/.gitconfig
    fi

    if [ -L ~/.tmux.conf ]; then
        echo -e "${YELLOW}删除符号链接: ~/.tmux.conf${NC}"
        rm ~/.tmux.conf
    fi

    if [ -L ~/.config/nvim ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/nvim${NC}"
        rm ~/.config/nvim
    fi

    if [ -L ~/.config/mise/config.toml ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/mise/config.toml${NC}"
        rm ~/.config/mise/config.toml
    fi

    if [ -L ~/.config/aerospace/aerospace.toml ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/aerospace/aerospace.toml${NC}"
        rm ~/.config/aerospace/aerospace.toml
    fi

    if [ -L ~/.config/ghostty/config ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/ghostty/config${NC}"
        rm ~/.config/ghostty/config
    fi

    if [ -L ~/.config/kitty/kitty.conf ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/kitty/kitty.conf${NC}"
        rm ~/.config/kitty/kitty.conf
    fi

    if [ -L ~/.config/kitty/current-theme.conf ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/kitty/current-theme.conf${NC}"
        rm ~/.config/kitty/current-theme.conf
    fi

    if [ -L ~/.config/yazi ]; then
        echo -e "${YELLOW}删除符号链接: ~/.config/yazi${NC}"
        rm ~/.config/yazi
    fi
}

# 卸载字体
uninstall_fonts() {
    echo -e "\n${GREEN}=== 卸载字体 ===${NC}"

    # 查找并删除 Maple Mono NF CN 字体
    local font_dir="$HOME/Library/Fonts"
    # 删除用户字体目录中的字体
    if [ -d "$font_dir" ]; then
        for font_file in "$font_dir"/MapleMono-NF-CN*.ttf; do
            if [ -f "$font_file" ]; then
                echo -e "${YELLOW}删除字体: $font_file${NC}"
                rm -f "$font_file"
            fi
        done
    fi

    # 刷新字体缓存
    fc-cache -fv >/dev/null 2>&1 || true
}

# 卸载 Homebrew 包（可选）
uninstall_homebrew_packages() {
    echo -e "\n${GREEN}=== 卸载 Homebrew 包（可选） ===${NC}"

    read -r -p "是否卸载通过 Homebrew 安装的包 (tmux, zoxide, fzf, ripgrep, fd, mise)? [y/N] " yn
    case "$yn" in
    [Yy]*)
        echo -e "${YELLOW}卸载 Homebrew 包...${NC}"
        brew uninstall tmux zoxide fzf ripgrep fd mise 2>/dev/null || true
        ;;
    *)
        echo -e "${YELLOW}跳过 Homebrew 包卸载${NC}"
        ;;
    esac

    read -r -p "是否卸载 AeroSpace? [y/N] " yn
    case "$yn" in
    [Yy]*)
        echo -e "${YELLOW}卸载 AeroSpace...${NC}"
        brew uninstall --cask nikitabobko/tap/aerospace 2>/dev/null || true
        ;;
    *)
        echo -e "${YELLOW}已跳过 AeroSpace 卸载${NC}"
        ;;
    esac

    read -r -p "是否卸载 borders? [y/N] " yn
    case "$yn" in
    [Yy]*)
        echo -e "${YELLOW}卸载 borders...${NC}"
        brew uninstall borders 2>/dev/null || true
        ;;
    *)
        echo -e "${YELLOW}已跳过 borders 卸载${NC}"
        ;;
    esac

    read -r -p "是否卸载 Yazi? [y/N] " yn
    case "$yn" in
    [Yy]*)
        echo -e "${YELLOW}卸载 Yazi...${NC}"
        brew uninstall yazi 2>/dev/null || true
        ;;
    *)
        echo -e "${YELLOW}已跳过 Yazi 卸载${NC}"
        ;;
    esac
}

# 清理缓存和临时文件
cleanup_cache() {
    echo -e "\n${GREEN}=== 清理缓存 ===${NC}"

    # 清理 Neovim 缓存
    if [ -d ~/.cache/nvim ]; then
        echo -e "${YELLOW}清理 Neovim 缓存${NC}"
        rm -rf ~/.cache/nvim
    fi

    # 清理 Zim 缓存
    if [ -d ~/.zim ]; then
        echo -e "${YELLOW}清理 Zim 缓存${NC}"
        rm -rf ~/.zim
    fi

    # 清理 Tmux 插件
    if [ -d ~/.tmux/plugins ]; then
        echo -e "${YELLOW}清理 Tmux 插件${NC}"
        rm -rf ~/.tmux/plugins
    fi
}

# 主卸载流程
main() {
    # 恢复备份文件
    restore_backups

    # 删除符号链接
    remove_symlinks

    # 卸载字体
    uninstall_fonts

    # 卸载 Homebrew 包（可选）
    uninstall_homebrew_packages

    # 清理缓存
    cleanup_cache

    echo -e "\n${GREEN}=== 卸载完成 ===${NC}"
    echo -e "${YELLOW}请重新启动终端应用以应用更改${NC}"
}

# 执行主函数
main
