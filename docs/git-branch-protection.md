# GitHub main 分支保护配置

本文件用于把 AI 开发规则从“建议”升级成 GitHub 级硬门禁。

## 为什么必须开启

本地脚本和 Git hooks 只能约束当前机器。Claude、Codex、其他电脑、GitHub 网页编辑都可能绕过本地 hooks。

最终必须依赖 GitHub 分支保护保证：

- 不能直接 push `main`。
- 必须走 Pull Request。
- 必须 CI 通过。
- 必须经过 review。
- 不能 force push。

## 推荐配置

进入 GitHub 仓库：

```text
Settings → Branches → Branch protection rules → Add rule
```

Branch name pattern：

```text
main
```

建议开启：

- Require a pull request before merging
- Require approvals：至少 1
- Dismiss stale pull request approvals when new commits are pushed
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Required status checks：`Check AI workflow rules`
- Require conversation resolution before merging
- Require linear history
- Do not allow bypassing the above settings
- Restrict who can push to matching branches
- Block force pushes
- Block deletions

## 什么时候开启

建议顺序：

1. 推送 `TASK-0002`。
2. 确认 GitHub Actions 能正常运行。
3. 开启 main 分支保护。
4. 后续所有开发走任务分支和 PR。

## 开启后的开发方式

```powershell
git checkout main
git pull
powershell -ExecutionPolicy Bypass -File scripts\start-task.ps1 -TaskId TASK-XXXX -CreateBranch
```

然后 Claude 在任务分支开发，最后创建 PR。

## Bootstrap 例外

Phase 0 初始治理文件可以直接 push `main`。分支保护开启后，不再允许这个例外。
