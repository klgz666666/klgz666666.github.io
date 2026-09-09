#!/usr/bin/env bash
# 增量更新简历网站（不动远程、只 push 改动）
set -e

cd "C:/Users/lenovo/WorkBuddy/2026-09-09-10-43-19/resume-deploy"

echo "============================================="
echo "  简历网站更新 push"
echo "============================================="

git add .
# 如无改动会报错，跳过 commit
if git diff --cached --quiet; then
  echo "没有改动，无需 push"
  exit 0
fi

git commit -m "feat: 加 CodePlay Hero 预览 + 下载 PDF 按钮 + GitHub 多链接"

read -s -p "请粘贴 GitHub Token（上次用过的也行）: " TOKEN
echo "(已接收)"
echo ""

if [ -z "$TOKEN" ]; then
  echo "❌ token 为空，退出"
  exit 1
fi

git push "https://klgz666666:${TOKEN}@github.com/klgz666666/klgz666666.github.io.git" main

echo ""
echo "✅ push 完成！30~90 秒后访问 https://klgz666666.github.io/ 看到效果"