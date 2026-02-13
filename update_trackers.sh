#!/bin/bash

# Tracker整合脚本
# 从多个源获取tracker列表并去重

set -e

echo "开始更新tracker列表..."

# 创建临时文件
TEMP_FILE=$(mktemp)

# 获取tracker列表
echo "正在从源获取tracker..."
curl -s https://ngosang.github.io/trackerslist/trackers_all.txt >> "$TEMP_FILE"
curl -s https://cf.trackerslist.com/all.txt >> "$TEMP_FILE"

# 去除空行、排序并去重
echo "正在处理和去重..."
grep . "$TEMP_FILE" | sort -u > trackers.txt

# 清理临时文件
rm -f "$TEMP_FILE"

# 统计tracker数量
TRACKER_COUNT=$(wc -l < trackers.txt)
echo "完成！共整合 $TRACKER_COUNT 个tracker"

# 生成 RouterOS DNS 命令文件
echo "正在生成 RouterOS DNS 命令..."
CNAME_TARGET="cfyd.mingxuele.com"

grep -E "^(udp|http|https|wss)://" trackers.txt | \
    sed -E 's#^[a-z]+://([^:/]+).*#\1#' | \
    grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | \
    grep -vE '^\[' | \
    awk -F. '{
        n=NF
        if (n >= 3 && (length($n) <= 3 || $n ~ /^(com|org|net|edu|gov)$/)) {
            print $(n-2)"."$(n-1)"."$n
        } else if (n >= 2) {
            print $(n-1)"."$n
        }
    }' | \
    sort -u | \
    while read domain; do
        echo "/ip dns static add name=$domain type=CNAME cname=$CNAME_TARGET match-subdomain=yes comment=tracker-auto"
    done > dns-routeros.rsc

DNS_COUNT=$(wc -l < dns-routeros.rsc)
echo "RouterOS DNS 命令生成完成！共 $DNS_COUNT 条记录"

# 更新README中的统计信息
CURRENT_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# 获取GitHub仓库信息
REPO_URL=$(git config --get remote.origin.url | sed 's/\.git$//' | sed 's|https://github.com/||')

cat > README.md << EOF
# Tracker List

自动整合的BitTorrent Tracker列表，每天自动更新。

## 使用方法

直接使用以下命令获取tracker列表：

\`\`\`bash
curl -s https://raw.githubusercontent.com/$REPO_URL/main/trackers.txt
\`\`\`

或者在qBittorrent等BT客户端中使用：
\`\`\`
https://raw.githubusercontent.com/$REPO_URL/main/trackers.txt
\`\`\`

## RouterOS DNS 配置

下载 RouterOS DNS 命令脚本：
\`\`\`bash
curl -s https://raw.githubusercontent.com/$REPO_URL/main/dns-routeros.rsc
\`\`\`

在 RouterOS 终端中导入：
\`\`\`
/tool fetch url="https://raw.githubusercontent.com/$REPO_URL/main/dns-routeros.rsc" dst-path=dns-routeros.rsc
/import dns-routeros.rsc
\`\`\`

> 注意：此脚本将 tracker 域名 CNAME 到 \`$CNAME_TARGET\`，共 $DNS_COUNT 条规则。

## 统计信息

- **Tracker数量**: $TRACKER_COUNT
- **RouterOS DNS规则**: $DNS_COUNT
- **最后更新**: $CURRENT_DATE
- **更新频率**: 每天自动更新

## 数据源

本项目整合以下tracker列表：
- [ngosang/trackerslist - All Trackers](https://ngosang.github.io/trackerslist/trackers_all.txt)
- [trackerslist.com - All Trackers](https://cf.trackerslist.com/all.txt)

## 许可证

MIT License
EOF

echo "README已更新"
