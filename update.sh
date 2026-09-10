#!/usr/bin/env bash
# 增量更新简历网站（不动远程仓库配置，只 push 本地改动）
set -e

cd "C:/Users/lenovo/WorkBuddy/2026-09-09-10-43-19/resume-deploy"

REPO_URL="github.com/klgz666666/klgz666666.github.io.git"

echo "============================================="
echo "  简历网站更新 push"
echo "============================================="

# 1) 有未提交改动就先提交
git add .
if git diff --cached --quiet; then
  echo "工作区没有新改动。"
else
  git commit -m "chore: 更新简历内容与链接"
  echo "已提交工作区改动。"
fi

# 2) 检查是否有本地提交还没推上去（关键：已 commit 未 push 的情况也要能推）
#    本仓库没有 origin/main 远程跟踪引用（历史 push 用完整 URL 完成），所以直接问远程
REMOTE_SHA=$(git ls-remote origin refs/heads/main 2>/dev/null | awk '{print $1}')
LOCAL_SHA=$(git rev-parse HEAD)
if [ -n "$REMOTE_SHA" ] && [ "$REMOTE_SHA" = "$LOCAL_SHA" ]; then
  echo "本地与远程一致，无需 push。"
  exit 0
fi
echo "本地有提交待推送（本地 ${LOCAL_SHA:0:7} → 远程 ${REMOTE_SHA:0:7}）。"

# 3) 收 token 并推送（token 只在这里手输，不会落盘）
read -s -p "请粘贴 GitHub Token（上次用过的也行）: " TOKEN
echo "(已接收)"
echo ""

if [ -z "$TOKEN" ]; then
  echo "❌ token 为空，退出"
  exit 1
fi

git push "https://klgz666666:${TOKEN}@${REPO_URL}" main

echo ""
echo "✅ push 完成！30~90 秒后访问 https://klgz666666.github.io/ 看到效果"
