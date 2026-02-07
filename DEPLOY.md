# 部署指南

## 1. 创建GitHub仓库

1. 在GitHub上创建一个新仓库，例如命名为 `trackers`
2. 不要初始化README、.gitignore或license（我们已经创建了）

## 2. 推送代码到GitHub

```bash
# 添加远程仓库（替换YOUR_USERNAME为你的GitHub用户名）
git remote add origin https://github.com/YOUR_USERNAME/trackers.git

# 推送代码
git branch -M main
git push -u origin main
```

## 3. 启用GitHub Actions

1. 进入仓库的 **Settings** > **Actions** > **General**
2. 确保 **Workflow permissions** 设置为 "Read and write permissions"
3. 保存设置

## 4. 手动触发首次更新（可选）

1. 进入仓库的 **Actions** 标签
2. 选择 "Update Trackers" workflow
3. 点击 "Run workflow" 按钮手动触发

## 5. 更新README中的链接

编辑 `README.md`，将所有 `YOUR_USERNAME` 替换为你的实际GitHub用户名。

## 自动化说明

- **定时执行**: 每天UTC时间00:00（北京时间08:00）自动运行
- **手动触发**: 可以在Actions页面手动触发更新
- **推送触发**: 每次推送到main分支也会触发更新

## 使用tracker列表

更新后，你可以通过以下URL访问tracker列表：

```
https://raw.githubusercontent.com/YOUR_USERNAME/trackers/main/trackers.txt
```

在BT客户端（如qBittorrent）中，可以直接添加这个URL作为tracker列表源。

## 本地测试

如果想在本地测试脚本：

```bash
./update_trackers.sh
```

## 添加更多数据源

如果想添加更多tracker数据源，编辑 `update_trackers.sh`，在获取tracker部分添加新的curl命令：

```bash
curl -s https://your-new-source.com/trackers.txt >> "$TEMP_FILE"
```
