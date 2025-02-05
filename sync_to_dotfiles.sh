#!/bin/bash

set -e                  # 如果有错误则退出脚本
DOTFILES_DIR=~/dotfiles # dotfiles 目录路径

# 定义需要同步的文件和目录
declare -A FILES_TO_SYNC=(
  ["~/.zshrc"]="$DOTFILES_DIR/shell/.zshrc"
  ["~/.gitconfig"]="$DOTFILES_DIR/git/.gitconfig"
  ["~/.tmux.conf"]="$DOTFILES_DIR/tmux/.tmux.conf"
  ["~/.config/nvim"]="$DOTFILES_DIR"
)

# 遍历每个文件并同步到 dotfiles 目录中
for src in "${!FILES_TO_SYNC[@]}"; do
  dest="${FILES_TO_SYNC[$src]}"

  # 检查源文件是否存在
  if [ -e "${src/#\~/$HOME}" ]; then
    echo "同步 $src 到 $dest"
    rsync -avh --progress "${src/#\~/$HOME}" "$dest"
  else
    echo "❗ 文件 $src 不存在，跳过"
  fi
done

echo "✅ 同步完成！"

# 提示用户提交到 Git
read -p "是否要提交更改到 Git 仓库？(y/n): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  cd $DOTFILES_DIR
  git add .
  git commit -m "更新 dotfiles 配置：$(date +'%Y-%m-%d %H:%M:%S')"
  git push origin main # 修改为你的分支名称
  echo "🚀 已提交更改到远程仓库！"
else
  echo "📂 更改未提交，请手动执行 git 命令。"
fi
