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
    
    # 获取当前 Homebrew 版本
    local current_version=$(brew --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    echo -e "${BLUE}当前 Homebrew 版本: ${current_version}${NC}"
    
    # 询问用户是否更新
    echo -e "${YELLOW}是否要更新 Homebrew? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo -e "${YELLOW}更新 Homebrew...${NC}"
      brew update
      echo -e "${GREEN}Homebrew 更新完成${NC}"
    else
      echo -e "${GREEN}跳过 Homebrew 更新${NC}"
    fi
  fi
}

# 安装前置依赖（Neovim、git、C 编译器 等）
install_prerequisites() {
  echo -e "\n${GREEN}=== 安装前置依赖 ===${NC}"
  
  # 安装基础工具
  echo -e "${YELLOW}安装基础工具...${NC}"
  if brew install git zsh curl fzf ripgrep fd tmux; then
    echo -e "${GREEN}基础工具安装完成${NC}"
  else
    echo -e "${RED}基础工具安装失败，请检查 Homebrew 状态${NC}"
    return 1
  fi

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
    echo -e "${YELLOW}Neovim 未安装，正在通过 Homebrew 安装...${NC}"
    if brew install neovim; then
      echo -e "${GREEN}Neovim 安装完成${NC}"
    else
      echo -e "${RED}Neovim 安装失败${NC}"
      all_good=false
    fi
  else
    echo -e "${BLUE}检测到 Neovim 已安装。${NC}"
    read -r -p "是否通过 Homebrew 升级 Neovim? [y/N] " yn
    case "$yn" in
      [Yy]* )
        echo -e "${YELLOW}正在升级 Neovim...${NC}"
        if brew upgrade neovim; then
          echo -e "${GREEN}Neovim 升级完成${NC}"
        else
          echo -e "${RED}Neovim 升级失败${NC}"
        fi
        ;;
      * )
        echo -e "${YELLOW}已跳过 Neovim 升级${NC}"
        ;;
    esac
  fi
}

# 可选安装 lazygit
install_lazygit() {
  echo -e "\n${GREEN}=== 可选：安装 lazygit ===${NC}"
  read -r -p "是否安装 lazygit? [y/N] " yn
  case "$yn" in
    [Yy]* )
      echo -e "${YELLOW}通过 Homebrew 安装 lazygit...${NC}"
      if brew install lazygit; then
        echo -e "${GREEN}lazygit 安装完成${NC}"
      else
        echo -e "${RED}lazygit 安装失败${NC}"
      fi
      ;;
    * )
      echo -e "${YELLOW}已跳过 lazygit 安装${NC}"
      ;;
  esac
}

# 安装字体（通过 Homebrew cask，可选）
install_fonts() {
  echo -e "\n${GREEN}=== 可选：安装 Maple Mono 字体 (Homebrew cask) ===${NC}"

  if ! command -v brew >/dev/null 2>&1; then
    echo -e "${RED}错误：Homebrew 未安装，无法通过 cask 安装字体${NC}"
    return 1
  fi

  read -r -p "是否通过 Homebrew 安装 Maple Mono 系列字体（Maple Mono / Maple Mono NF / Maple Mono NF CN）? [y/N] " yn
  case "$yn" in
    [Yy]* )
      local casks=("font-maple-mono" "font-maple-mono-nf" "font-maple-mono-nf-cn")
      for c in "${casks[@]}"; do
        echo -e "${YELLOW}检查并安装 ${c} ...${NC}"
        if brew list --cask "$c" >/dev/null 2>&1; then
          echo -e "${GREEN}${c} 已安装，跳过${NC}"
        else
          if brew install --cask "$c"; then
            echo -e "${GREEN}${c} 安装完成${NC}"
          else
            echo -e "${RED}${c} 安装失败，请手动重试${NC}"
          fi
        fi
      done
      echo -e "${YELLOW}安装完成后，请在终端应用中选择字体 'Maple Mono NF CN'（如需）${NC}"
      ;;
    * )
      echo -e "${YELLOW}已跳过字体安装${NC}"
      ;;
  esac
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
  
  # 额外确保 treesitter 正确安装
  echo -e "${YELLOW}正在确保 nvim-treesitter 正确安装...${NC}"
  if nvim --headless "+TSUpdate" +qa >/dev/null 2>&1; then
    echo -e "${GREEN}nvim-treesitter 更新完成${NC}"
  else
    echo -e "${YELLOW}nvim-treesitter 更新可能失败，建议手动运行: :TSUpdate${NC}"
  fi
}

# 检查并提示 tree-sitter CLI
check_treesitter_cli() {
  echo -e "\n${BLUE}=== Tree-sitter CLI 检查 ===${NC}"
  
  if command -v tree-sitter >/dev/null 2>&1; then
    local ts_version=$(tree-sitter --version 2>/dev/null | head -n1)
    echo -e "${GREEN}✓ tree-sitter CLI 已安装: ${ts_version}${NC}"
  else
    echo -e "${YELLOW}⚠️  tree-sitter CLI 未安装${NC}"
    echo -e "${YELLOW}nvim-treesitter 插件需要 tree-sitter CLI 来编译语法解析器${NC}"
    echo -e ""
    echo -e "${BLUE}推荐安装方法（使用 npm）：${NC}"
    echo -e "  ${GREEN}npm install -g tree-sitter-cli${NC}"
    echo -e ""
    echo -e "${BLUE}或使用 Cargo（Rust）：${NC}"
    echo -e "  ${GREEN}cargo install tree-sitter-cli${NC}"
    echo -e ""
    echo -e "${YELLOW}注意：'brew install tree-sitter' 只安装库，不包含 CLI 工具${NC}"
    echo -e "${YELLOW}      如需使用 Homebrew，请确保安装的是 tree-sitter-cli${NC}"
  fi
}

# 修复 nvim-treesitter 问题
fix_treesitter() {
  echo -e "\n${YELLOW}=== 修复 nvim-treesitter ===${NC}"
  echo -e "${YELLOW}此函数将清理并重新安装 nvim-treesitter${NC}"
  
  read -r -p "是否继续修复? [y/N] " yn
  case "$yn" in
    [Yy]* )
      echo -e "${YELLOW}1. 清理 Lazy 缓存...${NC}"
      rm -rf "$HOME/.local/share/nvim/lazy/nvim-treesitter"
      rm -rf "$HOME/.local/state/nvim/lazy/cache"
      
      echo -e "${YELLOW}2. 重新安装插件...${NC}"
      if nvim --headless "+Lazy! sync" +qa 2>&1 | grep -q "Error\|error"; then
        echo -e "${RED}插件同步可能遇到问题${NC}"
      else
        echo -e "${GREEN}插件同步完成${NC}"
      fi
      
      echo -e "${YELLOW}3. 更新 Treesitter 解析器...${NC}"
      if nvim --headless "+TSUpdateSync" +qa >/dev/null 2>&1; then
        echo -e "${GREEN}Treesitter 解析器更新完成${NC}"
      else
        echo -e "${YELLOW}部分解析器可能更新失败${NC}"
      fi
      
      echo -e "${GREEN}修复完成！${NC}"
      echo -e "${YELLOW}建议：${NC}"
      echo -e "  1. 重新打开 nvim"
      echo -e "  2. 运行 :checkhealth nvim-treesitter"
      echo -e "  3. 如仍有问题，运行 :TSInstall all"
      ;;
    * )
      echo -e "${YELLOW}已取消修复${NC}"
      ;;
  esac
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

# 可选安装 fnm
install_fnm() {
  echo -e "\n${GREEN}=== 可选：安装 fnm (Fast Node Manager) ===${NC}"
  if ! command -v fnm >/dev/null 2>&1; then
    echo -e "${YELLOW}fnm 未安装，正在通过 Homebrew 安装...${NC}"
    if brew install fnm; then
      echo -e "${GREEN}fnm 安装完成${NC}"
    else
      echo -e "${RED}fnm 安装失败${NC}"
    fi
  else
    echo -e "${GREEN}fnm 已安装${NC}"
  fi
}

# 安装 oh my tmux
# 可选安装 oh my tmux
install_oh_my_tmux() {
  echo -e "\n${GREEN}=== 可选：安装 oh my tmux ===${NC}"
  
  # 检查是否已安装
  if [ -d "$HOME/.local/share/tmux/oh-my-tmux" ]; then
    echo -e "${YELLOW}检测到 oh my tmux 已安装${NC}"
    read -r -p "是否更新 oh my tmux? [y/N] " yn
    case "$yn" in
      [Yy]* )
        echo -e "${GREEN}正在更新 oh my tmux...${NC}"
        ;;
      * )
        echo -e "${YELLOW}跳过 oh my tmux 更新${NC}"
        return 0
        ;;
    esac
  else
    read -r -p "是否安装 oh my tmux? [y/N] " yn
    case "$yn" in
      [Yy]* )
        echo -e "${GREEN}正在安装 oh my tmux...${NC}"
        ;;
      * )
        echo -e "${YELLOW}已跳过 oh my tmux 安装${NC}"
        return 0
        ;;
    esac
  fi

  # 检查 tmux 是否正在运行
  if pgrep -x tmux >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  检测到 tmux 正在运行${NC}"
    echo -e "${YELLOW}为了正确安装/更新配置，需要先关闭所有 tmux 会话${NC}"
    read -r -p "是否现在关闭所有 tmux 会话并继续? [y/N] " kill_yn
    case "$kill_yn" in
      [Yy]* )
        echo -e "${YELLOW}正在关闭 tmux 服务器...${NC}"
        tmux kill-server 2>/dev/null || pkill tmux 2>/dev/null
        sleep 1
        if pgrep -x tmux >/dev/null 2>&1; then
          echo -e "${RED}无法关闭 tmux，请手动关闭后重试${NC}"
          return 1
        fi
        echo -e "${GREEN}tmux 已关闭${NC}"
        ;;
      * )
        echo -e "${YELLOW}已跳过 oh my tmux 安装（请先关闭 tmux）${NC}"
        return 0
        ;;
    esac
  fi

  # 使用官方安装脚本
  if curl -fsSL "https://github.com/gpakosz/.tmux/raw/refs/heads/master/install.sh#$(date +%s)" | bash; then
    echo -e "${GREEN}oh my tmux 安装/更新完成${NC}"
    echo -e "${YELLOW}提示：自定义配置将通过符号链接部署到 ~/.config/tmux/tmux.conf.local${NC}"
  else
    echo -e "${RED}oh my tmux 安装/更新失败${NC}"
    return 1
  fi
}

# 可选：部署 Ghostty 配置
install_ghostty_config() {
  echo -e "\n${GREEN}=== 可选：部署 Ghostty 配置 ===${NC}"
  local repo_conf="$HOME/dotfiles/shell/ghostty_config"
  if [ ! -f "$repo_conf" ]; then
    echo -e "${YELLOW}警告：仓库中未找到 $repo_conf，跳过 Ghostty 配置部署${NC}"
    return 0
  fi

  read -r -p "是否将仓库的 Ghostty 配置部署到用户配置 (~/.config/ghostty/config)？ [y/N] " yn
  case "$yn" in
    [Yy]* )
      local target_dir="$HOME/.config/ghostty"
      local target_file="$target_dir/config"
      mkdir -p "$target_dir"
      if [ -e "$target_file" ]; then
        local backup="$target_file.bak.$(date +%Y%m%d%H%M%S)"
        echo -e "${YELLOW}检测到已有 Ghostty 配置，备份为: $backup${NC}"
        mv "$target_file" "$backup"
      fi
      if cp -f "$repo_conf" "$target_file"; then
        echo -e "${GREEN}已将仓库的 Ghostty 配置部署到 $target_file${NC}"
      else
        echo -e "${RED}部署 Ghostty 配置失败，请检查权限${NC}"
      fi
      ;;
    * )
      echo -e "${YELLOW}已跳过 Ghostty 配置部署${NC}"
      ;;
  esac
}

# 验证安装结果
verify_installation() {
  echo -e "\n${GREEN}=== 验证安装结果 ===${NC}"
  
  local all_good=true
  
  # 检查关键工具
  local tools=("nvim" "tmux" "zsh" "git" "fzf" "rg" "fd" "zoxide")
  for tool in "${tools[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
      echo -e "${GREEN}✓ $tool 已安装${NC}"
    else
      echo -e "${RED}✗ $tool 未找到${NC}"
      all_good=false
    fi
  done
  
  # 检查符号链接
  local symlinks=(
    "$HOME/.zshrc:$HOME/dotfiles/shell/.zshrc"
    "$HOME/.zimrc:$HOME/dotfiles/shell/.zimrc"
    "$HOME/.tmux.conf:$HOME/dotfiles/tmux/.tmux.conf"
    "$HOME/.config/nvim:$HOME/dotfiles/nvim"
  )
  
  for symlink_info in "${symlinks[@]}"; do
    local target="${symlink_info%%:*}"
    local source="${symlink_info##*:}"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      echo -e "${GREEN}✓ $target 符号链接正确${NC}"
    else
      echo -e "${RED}✗ $target 符号链接异常${NC}"
      all_good=false
    fi
  done
  
  # 检查字体
  if fc-list | grep -q "Maple Mono NF CN" 2>/dev/null; then
    echo -e "${GREEN}✓ Maple Mono NF CN 字体已安装${NC}"
  else
    echo -e "${YELLOW}⚠ Maple Mono NF CN 字体未安装（用户选择跳过或安装失败）${NC}"
    echo -e "${YELLOW}  如需安装，请访问: https://github.com/subframe7536/Maple-font/releases${NC}"
  fi
  
  if [ "$all_good" = true ]; then
    echo -e "\n${GREEN}🎉 所有关键组件安装验证通过！${NC}"
  else
    echo -e "\n${YELLOW}⚠️  部分组件可能存在问题，请检查上述输出${NC}"
  fi
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

  # 安装 lazygit （可选）
  install_lazygit

  # 安装字体（可选）
  install_fonts

  # 可选：部署 Ghostty 配置
  install_ghostty_config

  # 安装 Zim
  install_zim

  # 安装 fnm（可选）
  install_fnm

  # 安装 oh my tmux
  install_oh_my_tmux

  # 创建符号链接
  create_symlink "$HOME/dotfiles/shell/.zshrc" "$HOME/.zshrc"
  create_symlink "$HOME/dotfiles/shell/.zimrc" "$HOME/.zimrc"
  create_symlink "$HOME/dotfiles/tmux/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"
  create_symlink "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

  # 安装/更新 LazyVim
  install_lazyvim

  # 检查 tree-sitter CLI
  check_treesitter_cli

  # 验证安装
  verify_installation
  
  echo -e "\n${GREEN}=== 安装完成 ===${NC}"
  echo -e "${YELLOW}请重新启动终端应用并设置字体为 'Maple Mono NF CN'${NC}"
  echo -e "\n${GREEN}=== PowerLevel10k 主题配置 ===${NC}"
  echo -e "${YELLOW}首次打开终端时，PowerLevel10k 会自动运行配置向导${NC}"
  echo -e "${YELLOW}如需重新配置，请运行: p10k configure${NC}"
}

# 执行主函数
main

