#!/bin/bash

set -e # 遇到错误立即退出

# 彩色输出定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
# //
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

# 安装前置依赖（Neovim、git、C 编译器 等）
install_prerequisites() {
  echo -e "\n${GREEN}=== 安装前置依赖 ===${NC}"
  # 更新软件源索引（只执行一次）
  sudo apt update

  # 安装 Git
  if ! command -v git >/dev/null 2>&1; then
    echo -e "${YELLOW}Git 未安装，开始通过 apt 安装...${NC}"
    sudo apt install -y git
  fi

  # 安装 zsh、curl、fzf、tmux 基础环境
  sudo apt install -y zsh curl fzf neovim xclip tmux

  # 安装 C 编译器 (gcc) 或 clang
  if ! command -v gcc >/dev/null 2>&1 && ! command -v clang >/dev/null 2>&1; then
    echo -e "${YELLOW}C 编译器未安装，开始通过 apt 安装 build-essential...${NC}"
    sudo apt install -y build-essential
  fi

  # 安装 ripgrep 和 fd-find
  sudo apt install -y ripgrep fd-find
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi

  # 安装最新版 Neovim
  local should_install_nvim=false
  
  if ! command -v nvim >/dev/null 2>&1; then
    echo -e "${YELLOW}Neovim 未安装，正在下载最新版...${NC}"
    should_install_nvim=true
  else
    # 检查当前版本
    local current_version
    current_version=$(nvim --version | head -n1 | grep -o 'v[0-9]\+\.[0-9]\+' | head -n1)
    echo -e "${YELLOW}检测到 Neovim 版本: ${current_version}${NC}"
    
    # 检查是否为旧版本（小于 0.10.0）
    if [[ "$current_version" < "v0.10" ]]; then
      echo -e "${YELLOW}检测到较旧版本的 Neovim${NC}"
      read -r -p "是否安装最新版 Neovim? [Y/n] " yn
      case "$yn" in
        [Nn]* )
          echo -e "${YELLOW}跳过 Neovim 更新${NC}"
          ;;
        * )
          echo -e "${GREEN}开始安装最新版 Neovim...${NC}"
          should_install_nvim=true
          ;;
      esac
    else
      echo -e "${GREEN}Neovim 版本已是最新，跳过安装${NC}"
    fi
  fi
  
  if [ "$should_install_nvim" = true ]; then
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    # 建立可执行链接，容错处理路径变动
    sudo ln -sf /opt/nvim*/bin/nvim /usr/local/bin/nvim
    cd - >/dev/null 2>&1
    rm -rf "$temp_dir"
    echo -e "${GREEN}Neovim 安装完成${NC}"
  fi
}

# 安装（或更新）LazyVim 插件集
install_lazyvim() {
  echo -e "\n${GREEN}=== 安装/更新 LazyVim 插件 ===${NC}"
  if nvim --headless "+Lazy! sync" +qa; then
    echo -e "${GREEN}LazyVim 插件安装/更新完成${NC}"
  else
    echo -e "${RED}LazyVim 插件安装失败，请检查上述日志${NC}"
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

# 安装 Tmux 插件
install_tmux_plugins() {
  echo -e "\n${GREEN}=== 安装 Tmux 插件 (tpm) ===${NC}"

  # 检查 tpm 是否已克隆
  local tpm_path="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$tpm_path" ]; then
    echo -e "${GREEN}正在克隆 Tmux Plugin Manager (tpm)...${NC}"
    if ! git clone https://github.com/tmux-plugins/tpm "$tpm_path"; then
      echo -e "${RED}tpm 克隆失败，请检查网络或 Git。${NC}"
      return 1
    fi
  else
    echo -e "${YELLOW}检测到 tpm 已安装，跳过克隆。${NC}"
  fi

  # 执行 tpm 的插件安装脚本
  # 这会读取 ~/.tmux.conf 并安装其中列出的插件
  local install_script="$tpm_path/bin/install_plugins"
  if [ -f "$install_script" ]; then
    echo -e "${GREEN}开始安装/更新 Tmux 插件...${NC}"
    if "$install_script"; then
      echo -e "${GREEN}Tmux 插件安装/更新完成。${NC}"
    else
      echo -e "${RED}Tmux 插件安装失败。${NC}"
    fi
  else
    echo -e "${RED}错误：找不到 tpm 的安装脚本。${NC}"
  fi
}

# 可选安装 git-sync
install_git_sync() {
  echo -e "\n${GREEN}=== 可选：安装 git-sync 工具 ===${NC}"

  read -r -p "是否安装 git-sync (一个用于同步上游仓库的脚本)? [y/N] " yn
  case "$yn" in
    [Yy]* )
      echo -e "${GREEN}开始安装 git-sync...${NC}"
      local source_script="$HOME/dotfiles/git/git-sync.sh"
      local target_bin="/usr/local/bin/git-sync"

      if [ ! -f "$source_script" ]; then
          echo -e "${RED}错误: 找不到源文件 ${source_script}${NC}"
          return 1
      fi

      if sudo cp "$source_script" "$target_bin" && sudo chmod +x "$target_bin"; then
        echo -e "${GREEN}成功安装 git-sync 到 ${target_bin}${NC}"
      else
        echo -e "${RED}错误：git-sync 安装失败${NC}"
      fi
      ;;
    * )
      echo -e "${YELLOW}已跳过 git-sync 安装${NC}"
      ;;
  esac
}

# 主安装流程
main() {
  echo -e "\n${GREEN}=== 开始安装 dotfiles ===${NC}"

  # 安装基础依赖
  install_prerequisites

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

  # 安装 Tmux 插件（必须在创建 .tmux.conf 链接之后）
  install_tmux_plugins

  # 安装/更新 LazyVim
  install_lazyvim

  # 安装 git-sync 工具
  install_git_sync

  echo -e "\n${GREEN}=== 安装完成 ===${NC}"
}

# 执行主函数
main
