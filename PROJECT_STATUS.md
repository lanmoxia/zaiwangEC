# 项目状态

本文件用于窗口中断、跨设备开发、Claude/Codex 接力。聊天记录不是事实来源，本文件和 Git 状态才是事实来源。

```yaml
project: video-replication-agent
status: REVIEW_TASK_0002
current_task: TASK-0002
current_task_file: tasks/TASK-0002.md
current_task_progress_file: tasks/TASK-0002.progress.md
current_branch: main
last_good_commit: 90220d9
implementer: codex
reviewer: codex
current_step: TASK-0002 硬门禁系统已实现，等待提交、推送和 GitHub 分支保护配置
next_action: 提交并推送 TASK-0002，然后执行 scripts/install-githooks.ps1 并按 docs/git-branch-protection.md 开启 main 分支保护
blocked: false
updated_at: 2026-06-26
```

## 新窗口恢复流程

任何 Claude 或 Codex 新窗口接手时，必须先执行恢复，不得直接写代码。

1. 阅读 `CLAUDE.md`。
2. 阅读 `AGENTS.md`。
3. 阅读 `docs/ai-workflow.md`。
4. 阅读本文件。
5. 阅读 `current_task_file` 指向的任务单。
6. 阅读 `current_task_progress_file` 指向的任务进度文件。
7. 阅读 `docs/resume-protocol.md`。
8. 运行 `scripts/session-snapshot.ps1`。
9. 检查 Git 状态：
   - 当前分支
   - 最近 commit
   - 未提交修改
   - 是否与 `last_good_commit` 一致
10. 输出恢复报告。
11. 用户确认或任务状态一致后，再继续执行。

## 恢复报告格式

```text
当前任务：
任务状态：
当前分支：
最近 commit：
未提交修改：
已完成：
未完成：
下一步：
风险或不一致：
结论：可以继续 / 需要人工确认 / 需要恢复现场
```

## 状态维护规则

- 每个任务开始时更新 `current_task`、`current_task_file`、`current_branch`。
- 每个稳定 commit 后更新 `last_good_commit`。
- 如果窗口中断前无法提交，必须至少更新 `current_step` 和 `next_action`。
- 每个任务必须维护对应的 `tasks/TASK-XXXX.progress.md`。
- 如果发现代码状态、任务状态、PR 状态不一致，设置 `blocked: true` 并进入人工确认。
- 不允许用聊天摘要替代本文件。
