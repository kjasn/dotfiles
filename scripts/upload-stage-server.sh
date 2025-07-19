#!/bin/bash

#================================================================
#
#          FILE: upload-remote-server
#
#         USAGE: upload-remote-server <local_source_path> <remote_destination_path>
#
#   DESCRIPTION: 使用固定的 SSH 密钥，快速上传文件或目录到预设的服务器。
#
#================================================================

# --- 配置区: 请在这里修改为你自己的服务器信息 ---
REMOTE_USER="yourname"                 # 远程服务器的登录用户名
REMOTE_HOST="123.45.67.89"             # 远程服务器IP
REMOTE_PORT="22"                       # 远程服务器的SSH端口，默认22
SSH_KEY_PATH="$HOME/.ssh/your_key" # <--- 在这里填入你固定的私钥路径！
# --- 配置区结束 ---

# 函数: 显示使用方法并退出
show_usage() {
    echo "Usage: $(basename "$0") <local_source_path> <remote_destination_path>"
    echo ""
    echo "  <local_source_path>  : 要上传的本地文件或目录的路径。"
    echo "  <remote_dest_path>   : 文件在远程服务器上存放的路径 (绝对路径)。"
    echo ""
    echo "  示例:"
    echo "  # 上传本地 'my_project' 目录到服务器的 '/var/www/html/' 目录下"
    echo "  $(basename "$0") ./my_project /var/www/html/"
    exit 1
}

# --- 检查参数数量 ---
if [ "$#" -ne 2 ]; then
    echo "错误: 需要提供源路径和远程目标路径。"
    show_usage
fi

SOURCE_PATH="$1"
REMOTE_DEST_PATH="$2"

# --- 输入验证 ---
# 检查私钥文件是否存在
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "错误: 脚本中配置的 SSH 密钥文件不存在: $SSH_KEY_PATH"
    echo "请编辑 $(realpath "$0") 并修正 SSH_KEY_PATH 的值。"
    exit 1
fi

# 检查本地源文件/目录是否存在
if [ ! -e "$SOURCE_PATH" ]; then
    echo "错误: 本地源文件或目录不存在: $SOURCE_PATH"
    exit 1
fi

# --- 核心逻辑: 上传前检查远程文件 ---
# 1. 构造远程文件的完整路径
#    - basename "$SOURCE_PATH" 获取本地源的文件名或目录名
#    - ${REMOTE_DEST_PATH%/} 会去掉远程路径末尾的 / (如果有)，保证路径拼接正确
REMOTE_TARGET_FULL_PATH="${REMOTE_DEST_PATH%/}/$(basename "$SOURCE_PATH")"
PROCEED_UPLOAD=false # 设置一个标志位，决定是否执行上传

echo "============================================="
echo "准备上传文件..."
echo "  - 服务器:   ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PORT}"
echo "  - 本地源:   ${SOURCE_PATH}"
echo "  - 远程目标: ${REMOTE_TARGET_FULL_PATH}" # 显示完整的远程路径
echo "  - 使用密钥: ${SSH_KEY_PATH}"
echo "============================================="

echo "--> 正在检查远程服务器上是否存在同名文件/目录..."

# 2. 通过 ssh 执行 'test -e' 命令来检查文件是否存在
#    如果文件存在，ssh 命令的退出码为 0，if 条件成立
if ssh -p "$REMOTE_PORT" -i "$SSH_KEY_PATH" "${REMOTE_USER}@${REMOTE_HOST}" "test -e \"$REMOTE_TARGET_FULL_PATH\""; then
    # 如果文件存在，提示用户
    echo "⚠️  警告: 远程目标 '${REMOTE_TARGET_FULL_PATH}' 已存在。"

    # 3. 读取用户输入，-n 1 表示只读一个字符，-r 防止反斜杠转义
    read -p "是否要覆盖? (y/N) " -n 1 -r REPLY
    echo # 输出一个换行符，使界面更美观

    # 4. 判断用户输入
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo "--> 用户选择覆盖，准备上传..."
        PROCEED_UPLOAD=true
    else
        echo "--> 操作已由用户取消。"
    fi
else
    # 如果文件不存在，直接准备上传
    echo "--> 远程目标不存在，直接准备上传..."
    PROCEED_UPLOAD=true
fi

# 5. 根据标志位决定是否执行 scp
if [ "$PROCEED_UPLOAD" = true ]; then
    echo ""
    echo "--> 开始上传..."

    # 使用 -q 选项可以在上传时保持安静，如果想看进度条可以去掉 -q
    scp -q -r -P "$REMOTE_PORT" -i "$SSH_KEY_PATH" "$SOURCE_PATH" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DEST_PATH}"

    # 检查 scp 命令的退出状态
    if [ $? -eq 0 ]; then
        echo "✅ 文件上传成功!"
    else
        echo "❌ 文件上传失败。请检查错误信息、网络连接和服务器配置。"
        exit 1
    fi
else
    # 如果用户选择不覆盖，脚本正常退出
    exit 0
fi

exit 0
