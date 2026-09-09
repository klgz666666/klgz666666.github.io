#!/usr/bin/env bash
# 部署简历网站为 user site（https://klgz666666.github.io/）
set -e

GH_USER='klgz666666'
REPO='klgz666666.github.io'   # user site 必须严格匹配用户名

cd "C:/Users/lenovo/WorkBuddy/2026-09-09-10-43-19/resume-deploy"

echo "============================================="
echo "  个人简历网站 → GitHub user site 部署"
echo "  最终地址：https://${GH_USER}.github.io/"
echo "============================================="
read -s -p "请粘贴 GitHub Token: " TOKEN
echo "(已接收)"
echo ""

if [ -z "$TOKEN" ]; then
  echo "❌ token 为空，退出"
  exit 1
fi

# 写到文件避免 shell 转义问题
cat > /tmp/repo_body.json <<'JSON'
{"name":"klgz666666.github.io","description":"吴瑶珍的个人简历网站 · Resume","private":false,"auto_init":false}
JSON

echo "1) 创建 user site 仓库..."
HTTP_CODE=$(curl -sS -o /tmp/repo_resp.json -w "%{http_code}" \
  -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  --data @/tmp/repo_body.json)
echo "    HTTP 状态: $HTTP_CODE"
cat /tmp/repo_resp.json
echo ""

if [ "$HTTP_CODE" = "422" ]; then
  echo "    ⚠️  仓库已存在，跳过创建"
elif [ "$HTTP_CODE" != "201" ]; then
  echo "    ❌ 仓库创建失败"
  exit 1
fi

echo ""
echo "2) 推送代码到 main 分支..."
git push "https://${GH_USER}:${TOKEN}@github.com/${GH_USER}/${REPO}.git" main

echo ""
echo "============================================="
echo "  ✅ 推送完成！user site 会自动生效"
echo "  - 简历地址：https://${GH_USER}.github.io/"
echo "  - 等 30~90 秒让 GitHub 部署"
echo "============================================="