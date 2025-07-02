#!/bin/zsh
# 自动同步上游分支 (仅允许 master/main),使用方法:
# 颜色
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

# 检查参数
if [[ "$1" != "master" && "$1" != "main" ]]; then
    # echo "${RED}✗ 错误：只支持同步 master/main 分支${NC}"
    # echo "用法: ${BLUE}sync_upstream.sh [master|main]${NC}"
    # exit 1
    echo "${YELLOW}! 要同步的分支不是 master/main 分支${NC}"
fi

branch="$1"

# 检查Git仓库
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "${RED}✗ 当前目录不是 Git 仓库${NC}"
        exit 1
    fi
}

# 检查上游远程
check_upstream() {
    if ! git remote | grep -q upstream; then
        echo "${YELLOW}ℹ 未配置 upstream 远程仓库${NC}"
        echo "请执行: ${BLUE}git remote add upstream <仓库URL>${NC}"
        exit 1
    fi
}

# 主流程
main() {
    check_git_repo
    check_upstream

    echo "${YELLOW}⚠️ 即将执行以下操作：${NC}"
    echo "1. 从 ${BLUE}upstream/${branch}${NC} 强制同步到本地分支 ${GREEN}${branch}${NC}"
    echo "2. 强制推送到 ${BLUE}origin/${branch}${NC}"
    echo ""
    read -q "confirm?${YELLOW}确认继续吗？(y/N) ${NC}"

    if [[ "$confirm" != "y" ]]; then
        echo "\n${RED}操作已取消${NC}"
        exit 0
    fi

    echo "\n${GREEN}▶ 开始同步...${NC}"

    # 执行同步
    git fetch upstream
    git checkout -q "$branch"
    git reset --hard "upstream/$branch"
    git push --force origin "$branch"

    echo "${GREEN}✓ 同步完成！${NC}"
    echo "本地 ${GREEN}${branch}${NC} 和远程 ${BLUE}origin/${branch}${NC} 已更新"
}

main
