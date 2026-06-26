# 项目状态

本文件用于窗口中断、跨设备开发、Claude/Codex 接力。聊天记录不是事实来源，本文件和 Git 状态才是事实来源。

```yaml
project: video-replication-agent
status: READY_FOR_TASK_0001
current_task: TASK-0001
current_task_file: tasks/TASK-0001.md
current_branch: not_initialized
last_good_commit: none
implementer: unassigned
reviewer: codex
current_step: AI 开发闭环规则文件已建立，TASK-0001 已批准
next_action: 提交并推送当前治理骨架，然后让 Claude 读取任务单并输出 TASK-0001 实现计划
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
6. 检查 Git 状态：
   - 当前分支
   - 最近 commit
   - 未提交修改
   - 是否与 `last_good_commit` 一致
7. 输出恢复报告。
8. 用户确认或任务状态一致后，再继续执行。

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
- 如果发现代码状态、任务状态、PR 状态不一致，设置 `blocked: true` 并进入人工确认。
- 不允许用聊天摘要替代本文件。
