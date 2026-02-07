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

# 更新README中的统计信息
CURRENT_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
cat > README.md << EOF
# Tracker List

自动整合的BitTorrent Tracker列表，每天自动更新。

## 使用方法

直接使用以下命令获取tracker列表：

\`\`\`bash
curl -s https://raw.githubusercontent.com/edice1314/trackers/main/trackers.txt
\`\`\`

或者在qBittorrent等BT客户端中使用：
\`\`\`
https://raw.githubusercontent.com/edice1314/trackers/main/trackers.txt
\`\`\`

## 统计信息

- **Tracker数量**: $TRACKER_COUNT
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
