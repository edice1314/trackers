# 添加GitHub Actions Workflow

由于Token权限限制，需要手动添加workflow文件。请按以下步骤操作：

## 方法一：通过GitHub网页添加（推荐）

1. 访问你的仓库：https://github.com/edice1314/trackers

2. 点击 **Add file** → **Create new file**

3. 在文件名输入框中输入：`.github/workflows/update.yml`
   （GitHub会自动创建目录结构）

4. 复制以下内容到文件编辑器：

```yaml
name: Update Trackers

on:
  schedule:
    # 每天UTC时间00:00执行（北京时间08:00）
    - cron: '0 0 * * *'
  workflow_dispatch: # 允许手动触发
  push:
    branches:
      - main

jobs:
  update:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Update tracker list
        run: |
          chmod +x update_trackers.sh
          ./update_trackers.sh

      - name: Check for changes
        id: check_changes
        run: |
          git diff --quiet trackers.txt || echo "changed=true" >> $GITHUB_OUTPUT

      - name: Commit and push if changed
        if: steps.check_changes.outputs.changed == 'true'
        run: |
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add trackers.txt README.md
          git commit -m "Auto update trackers - $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
          git push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

5. 点击 **Commit changes**

6. 在弹出的对话框中点击 **Commit changes** 确认

## 方法二：使用本地文件推送（需要workflow权限的Token）

如果你有带workflow权限的Token，可以：

```bash
git add .github/workflows/update.yml
git commit -m "Add GitHub Actions workflow"
git push
```

## 启用GitHub Actions权限

添加workflow后，需要设置权限：

1. 进入仓库的 **Settings** → **Actions** → **General**

2. 滚动到 **Workflow permissions**

3. 选择 **Read and write permissions**

4. 勾选 **Allow GitHub Actions to create and approve pull requests**

5. 点击 **Save**

## 手动触发首次更新

1. 进入 **Actions** 标签

2. 选择 **Update Trackers** workflow

3. 点击 **Run workflow** → **Run workflow**

4. 等待执行完成

## 验证自动化

完成后，你的tracker列表将：
- 每天UTC 00:00（北京时间08:00）自动更新
- 可以手动触发更新
- 每次推送到main分支也会触发更新

访问你的tracker列表：
https://raw.githubusercontent.com/edice1314/trackers/main/trackers.txt
