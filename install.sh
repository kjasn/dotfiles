#!/bin/bash

set -e # 遇到错误立即退出
set -e # 遇到错误立即退出

# 彩色输出定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# 检查并安装 Homebrew
install_homebrew() {
  echo -e "\n${GREEN}=== 检查 Homebrew ===${NC}"
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${YELLOW}Homebrew 未安装，正在安装...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 添加 Homebrew 到 PATH（针对 Apple Silicon Mac）
    if [[ $(uname -m) == "arm64" ]]; then
      echo -e "${YELLOW}检测到 Apple Silicon Mac，添加 Homebrew 到 PATH...${NC}"
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    echo -e "${GREEN}Homebrew 已安装${NC}"
    # 更新 Homebrew
    echo -e "${YELLOW}更新 Homebrew...${NC}"
    brew update
  fi
}

# 检查并安装 Homebrew
install_homebrew() {
  echo -e "\n${GREEN}=== 检查 Homebrew ===${NC}"
  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${YELLOW}Homebrew 未安装，正在安装...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 添加 Homebrew 到 PATH（针对 Apple Silicon Mac）
    if [[ $(uname -m) == "arm64" ]]; then
      echo -e "${YELLOW}检测到 Apple Silicon Mac，添加 Homebrew 到 PATH...${NC}"
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    echo -e "${GREEN}Homebrew 已安装${NC}"
    # 更新 Homebrew
    echo -e "${YELLOW}更新 Homebrew...${NC}"
    brew update
  fi
}

# 安装前置依赖（Neovim、git、C 编译器 等）
install_prerequisites() {
  echo -e "\n${GREEN}=== 安装前置依赖 ===${NC}"
  
  # 安装基础工具
  echo -e "${YELLOW}安装基础工具...${NC}"
  brew install git zsh curl fzf ripgrep fd

  # 安装 C 编译器 (Xcode Command Line Tools)
  if ! command -v clang >/dev/null 2>&1; then
    echo -e "${YELLOW}安装 Xcode Command Line Tools...${NC}"
    xcode-select --install || true
  fi

  # 安装 zoxide (智能 cd 命令)
  if ! command -v zoxide >/dev/null 2>&1; then
    echo -e "${YELLOW}zoxide 未安装，正在安装...${NC}"
    brew install zoxide
  else
    echo -e "${YELLOW}检测到 zoxide 已安装，跳过安装${NC}"
  fi

  # 安装最新版 Neovim
  if ! command -v nvim >/dev/null 2>&1; then
    echo -e "${YELLOW}Neovim 未安装，正在下载最新版...${NC}"
    install_neovim=true
  else
    # 检查当前 Neovim 版本
    current_version=$(nvim --version | head -n1 | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+')
    echo -e "${BLUE}当前 Neovim 版本: ${current_version}${NC}"
    echo -e "${YELLOW}是否要安装/升级到最新版本的 Neovim? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      install_neovim=true
    else
      install_neovim=false
      echo -e "${GREEN}跳过 Neovim 安装${NC}"
    fi
  fi

  if [ "$install_neovim" = true ]; then
    echo -e "${YELLOW}正在下载最新版 Neovim...${NC}"
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-macos-x86_64.tar.gz
    # 建立可执行链接
    sudo ln -sf /opt/nvim-macos-x86_64/bin/nvim /usr/local/bin/nvim
    cd - >/dev/null 2>&1
    rm -rf "$temp_dir"
    echo -e "${GREEN}Neovim 安装完成${NC}"
  fi
}

# 安装字体
install_fonts() {
  echo -e "\n${GREEN}=== 安装字体 ===${NC}"
  
  # 检查是否已安装 Maple Mono NF CN 字体
  if fc-list | grep -q "Maple Mono NF CN"; then
    echo -e "${YELLOW}Maple Mono NF CN 字体已安装，跳过安装${NC}"
    return 0
  fi

  echo -e "${YELLOW}正在安装 Maple Mono NF CN 字体...${NC}"
  
  # 创建字体目录
  local font_dir="$HOME/Library/Fonts"
  mkdir -p "$font_dir"
  
  # 下载并安装字体
  local font_url="https://github.com/subframe7536/Maple-font/releases/download/v6.4/MapleMono-NF-CN.zip"
  local temp_dir=$(mktemp -d)
  
  if curl -L "$font_url" -o "$temp_dir/MapleMono-NF-CN.zip"; then
    cd "$temp_dir"
    unzip -q MapleMono-NF-CN.zip
    cp -f *.ttf "$font_dir/"
    cd - >/dev/null 2>&1
    rm -rf "$temp_dir"
    
    # 刷新字体缓存
    fc-cache -fv >/dev/null 2>&1 || true
    
    echo -e "${GREEN}字体安装完成${NC}"
    echo -e "${YELLOW}请在终端应用中设置字体为 'Maple Mono NF CN'${NC}"
  else
    echo -e "${RED}字体下载失败，请手动安装${NC}"
  fi
}

# 安装（或更新）LazyVim 插件集
install_lazyvim() {
  echo -e "\n${GREEN}=== 安装/更新 LazyVim 插件 ===${NC}"
  echo -e "${YELLOW}正在后台安装 LazyVim 插件，请稍候...${NC}"
  if nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1; then
    echo -e "${GREEN}LazyVim 插件安装/更新完成${NC}"
  else
    echo -e "${RED}LazyVim 插件安装失败${NC}"
    echo -e "${YELLOW}如需查看详细错误信息，请手动运行: nvim --headless \"+Lazy! sync\" +qa${NC}"
  fi
}

# 安装 Zim zsh 框架
install_zim() {
  echo -e "\n${GREEN}=== 安装 Zim (Zsh 框架) ===${NC}"
  local ZIM_DIR="${ZDOTDIR:-$HOME}/.zim"
  if [ -d "$ZIM_DIR" ]; then
    echo -e "${YELLOW}检测到 Zim 已存在，跳过安装${NC}"
    return 0
  fi

  if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${RED}错误：zsh 未安装，无法安装 Zim${NC}"
    return 1
  fi

  # 使用官方脚本安装 Zim
  if curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh; then
    echo -e "${GREEN}Zim 安装完成${NC}"
    # 确保 zsh 在 /etc/shells 中，并将默认 shell 设置为 zsh
    local ZSH_PATH
    ZSH_PATH="$(command -v zsh)"
    if [ -n "$ZSH_PATH" ]; then
      # 若 /etc/shells 中缺少该路径，则追加
      if ! grep -q "^${ZSH_PATH}$" /etc/shells 2>/dev/null; then
        echo -e "${YELLOW}zsh 路径 ${ZSH_PATH} 未在 /etc/shells，正在追加...${NC}"
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
      fi

      # 若当前默认 shell 不是 zsh，则切换
      if [ "$SHELL" != "$ZSH_PATH" ]; then
        echo -e "${GREEN}切换默认 shell 为 zsh (${ZSH_PATH})${NC}"
        sudo chsh -s "$ZSH_PATH" "$USER"
        echo -e "${YELLOW}请重新登录终端以使新的 shell 设置生效${NC}"
      fi
    fi
  else
    echo -e "${RED}Zim 安装失败，请检查网络或权限${NC}"
    return 1
  fi
}

# 可选安装 nvm
install_nvm() {
  echo -e "\n${GREEN}=== 可选：安装 nvm (Node Version Manager) ===${NC}"
  # 已安装则跳过
  if command -v nvm >/dev/null 2>&1; then
    echo -e "${YELLOW}检测到 nvm 已安装，跳过安装${NC}"
    return 0
  fi

  # 交互确认
  read -r -p "是否安装 nvm? [y/N] " yn
  case "$yn" in
    [Yy]* )
      echo -e "${GREEN}开始安装 nvm...${NC}"
      # shellcheck disable=SC2046
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
      echo -e "${GREEN}nvm 安装完成，请重新加载终端或执行 'source ~/.nvm/nvm.sh'${NC}"
      ;;
    * )
      echo -e "${YELLOW}已跳过 nvm 安装${NC}"
      ;;
  esac
}

# 主安装流程
main() {
  echo -e "\n${GREEN}=== 开始安装 MacOS dotfiles ===${NC}"

  # 检查操作系统
  if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}错误：此脚本仅适用于 MacOS${NC}"
    exit 1
  fi

  # 安装 Homebrew
  install_homebrew

  # 安装基础依赖
  install_prerequisites

  # 安装字体
  install_fonts

  # 安装 Zim
  install_zim

  # 安装 nvm（可选）
  install_nvm

  # 创建符号链接
  create_symlink "$HOME/dotfiles/shell/.zshrc" "$HOME/.zshrc"
  create_symlink "$HOME/dotfiles/shell/.zimrc" "$HOME/.zimrc"
  create_symlink "$HOME/dotfiles/git/.gitconfig" "$HOME/.gitconfig"
  create_symlink "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"
  create_symlink "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

  # 安装/更新 LazyVim
  install_lazyvim

  # 安装 git-sync 工具
  echo -e "\n${GREEN}=== 安装 git-sync 工具 ===${NC}"
  if sudo cp "$HOME/dotfiles/git/sync_upstream.sh" /usr/local/bin/git-sync &&
    sudo chmod +x /usr/local/bin/git-sync; then
    echo -e "${GREEN}成功安装 git-sync 到 /usr/local/bin/${NC}"
  else
    echo -e "${RED}错误：git-sync 安装失败${NC}"
    return 1
  fi

  echo -e "\n${GREEN}=== 安装完成 ===${NC}"
  echo -e "${YELLOW}请重新启动终端应用并设置字体为 'Maple Mono NF CN'${NC}"
}

# 执行主函数
main

