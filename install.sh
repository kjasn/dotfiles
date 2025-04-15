#!/bin/bash

set -e  # 遇到错误立即退出

# 彩色输出定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 创建符号链接（带备份和验证）
create_symlink() {
    local source_file="$1"
    local target_file="$2"
    
    # 检查源文件是否存在
    if [ ! -e "$source_file" ]; then
        echo -e "${RED}错误：源文件 '$source_file' 不存在${NC}"
        return 1
    fi

    # 如果目标已存在
    if [ -e "$target_file" ]; then
        # 如果是符号链接且已经指向正确位置
        if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$source_file" ]; then
            echo -e "${YELLOW}跳过：$target_file 已经正确链接到 $source_file${NC}"
            return 0
        fi
        
        # 备份原有文件
        local backup_file="${target_file}.bak.$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}备份原有文件：$target_file -> $backup_file${NC}"
        mv "$target_file" "$backup_file"
    fi

    # 确保目标目录存在
    mkdir -p "$(dirname "$target_file")"
    
    # 创建链接
    if ln -s "$source_file" "$target_file"; then
        echo -e "${GREEN}创建链接：$target_file -> $source_file${NC}"
    else
        echo -e "${RED}错误：无法创建链接 $target_file${NC}"
        return 1
    fi
}

# 主安装流程
main() {
    echo -e "\n${GREEN}=== 开始安装 dotfiles ===${NC}"
    
    # 创建符号链接
    create_symlink "$HOME/dotfiles/shell/.zshrc" "$HOME/.zshrc"
    create_symlink "$HOME/dotfiles/git/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
    create_symlink "$HOME/dotfiles/nvim" "$HOME/.config/nvim"  
    
    # 安装 git-sync 工具
    echo -e "\n${GREEN}=== 安装 git-sync 工具 ===${NC}"
    if sudo cp "$HOME/dotfiles/git/sync_upstream.sh" /usr/local/bin/git-sync && \
       sudo chmod +x /usr/local/bin/git-sync; then
        echo -e "${GREEN}成功安装 git-sync 到 /usr/local/bin/${NC}"
    else
        echo -e "${RED}错误：git-sync 安装失败${NC}"
        return 1
    fi
    
    echo -e "\n${GREEN}=== 安装完成 ===${NC}"
}

# 执行主函数
main