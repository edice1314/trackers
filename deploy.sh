#!/bin/bash

# GitHub快速部署脚本

echo "=========================================="
echo "  Trackers项目 - GitHub部署助手"
echo "=========================================="
echo ""

# 检查git配置
echo "检查Git配置..."
GIT_NAME=$(git config --global user.name 2>/dev/null)
GIT_EMAIL=$(git config --global user.email 2>/dev/null)

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
    echo "⚠️  Git用户信息未配置"
    echo ""
    read -p "请输入你的GitHub用户名: " username
    read -p "请输入你的GitHub邮箱: " email

    git config --global user.name "$username"
    git config --global user.email "$email"

    echo "✓ Git配置完成"
else
    echo "✓ Git已配置："
    echo "  用户名: $GIT_NAME"
    echo "  邮箱: $GIT_EMAIL"
fi

echo ""
echo "=========================================="
echo "  下一步操作："
echo "=========================================="
echo ""
echo "1. 在浏览器中打开: https://github.com/new"
echo ""
echo "2. 创建仓库："
echo "   - Repository name: trackers"
echo "   - 选择 Public"
echo "   - 不要勾选任何初始化选项"
echo ""
echo "3. 创建后，输入你的GitHub用户名来推送代码"
echo ""
read -p "请输入你的GitHub用户名（或按Ctrl+C退出）: " github_user

if [ -z "$github_user" ]; then
    echo "❌ 用户名不能为空"
    exit 1
fi

echo ""
echo "准备推送到: https://github.com/$github_user/trackers"
read -p "确认继续？(y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消"
    exit 0
fi

echo ""
echo "开始推送..."

# 切换到main分支
git branch -M main

# 添加远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    echo "移除旧的远程仓库..."
    git remote remove origin
fi

git remote add origin "https://github.com/$github_user/trackers.git"

# 推送
echo ""
echo "正在推送到GitHub..."
echo "⚠️  如果提示输入密码，请使用Personal Access Token"
echo "   获取Token: https://github.com/settings/tokens"
echo ""

if git push -u origin main; then
    echo ""
    echo "=========================================="
    echo "  ✓ 部署成功！"
    echo "=========================================="
    echo ""
    echo "仓库地址: https://github.com/$github_user/trackers"
    echo "Tracker链接: https://raw.githubusercontent.com/$github_user/trackers/main/trackers.txt"
    echo ""
    echo "⚠️  重要：请完成以下步骤："
    echo ""
    echo "1. 启用GitHub Actions权限："
    echo "   https://github.com/$github_user/trackers/settings/actions"
    echo "   选择 'Read and write permissions'"
    echo ""
    echo "2. 更新README中的用户名："
    echo "   将 YOUR_USERNAME 替换为 $github_user"
    echo ""
    echo "3. 手动触发首次更新（可选）："
    echo "   https://github.com/$github_user/trackers/actions"
    echo ""
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因："
    echo "1. 仓库尚未创建"
    echo "2. 认证失败（需要使用Personal Access Token）"
    echo "3. 网络问题"
    echo ""
    echo "请查看错误信息并重试"
fi
