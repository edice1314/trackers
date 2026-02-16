# Tracker List

自动整合的BitTorrent Tracker列表，每天自动更新。

## 使用方法

直接使用以下命令获取tracker列表：

```bash
curl -s https://raw.githubusercontent.com/edice1314/trackers/main/trackers.txt
```

或者在qBittorrent等BT客户端中使用：
```
https://raw.githubusercontent.com/edice1314/trackers/main/trackers.txt
```

## RouterOS DNS 配置

下载 RouterOS DNS 命令脚本：
```bash
curl -s https://raw.githubusercontent.com/edice1314/trackers/main/dns-routeros.rsc
```

在 RouterOS 终端中导入：
```
/tool fetch url="https://raw.githubusercontent.com/edice1314/trackers/main/dns-routeros.rsc" dst-path=dns-routeros.rsc
/import dns-routeros.rsc
```

> 注意：此脚本将 tracker 域名 CNAME 到 `cfyd.mingxuele.com`，共 139 条规则。

## 统计信息

- **Tracker数量**: 164
- **RouterOS DNS规则**: 139
- **最后更新**: 2026-02-16 00:42:24 UTC
- **更新频率**: 每天自动更新

## 数据源

本项目整合以下tracker列表：
- [ngosang/trackerslist - All Trackers](https://ngosang.github.io/trackerslist/trackers_all.txt)
- [trackerslist.com - All Trackers](https://cf.trackerslist.com/all.txt)

## 许可证

MIT License
