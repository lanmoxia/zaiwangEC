# 中断恢复与接力协议

本协议用于处理 Claude、Codex、终端、网络、API、VS Code、GitHub 任一环节中断后的恢复。

核心原则：恢复时只相信仓库事实，不相信聊天记忆。

## 适用场景

- Claude Code 403、网络中断、窗口关闭。
- Codex 会话中断或换窗口。
- 公司/家里两地切换。
- 本地开发环境重启。
- PR 修复过程中上下文丢失。
- 不确定当前任务做到哪一步。

## 恢复前禁止事项

新会话接手时，禁止直接：

- 修改文件。
- 运行安装依赖。
- 删除文件。
- 切换分支。
- 合并代码。
- 推送代码。
- 根据聊天记忆继续实现。

必须先完成恢复检查。

## 固定恢复流程

按顺序执行：

1. 阅读 `CLAUDE.md`。
2. 阅读 `AGENTS.md`。
3. 阅读 `PROJECT_STATUS.md`。
4. 阅读 `docs/ai-workflow.md`。
5. 阅读本文件。
6. 阅读当前任务单，例如 `tasks/TASK-0001.md`。
7. 阅读当前任务进度文件，例如 `tasks/TASK-0001.progress.md`。
8. 运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\session-snapshot.ps1
powershell -ExecutionPolicy Bypass -File scripts\check-task-state.ps1 -Mode Any -AllowDirty
```

9. 输出恢复报告。
10. 等待用户确认，再继续。

## 恢复报告格式

```text
恢复结论：可以继续 / 需要人工确认 / 需要恢复现场

当前任务：
任务状态：
任务进度文件：
当前分支：
最新 commit：
工作区是否干净：
未提交修改：
远程同步状态：

已完成：
未完成：
下一步建议：
风险或不一致：
```

## 状态判断规则

### 可以继续

满足：

- 当前分支符合 `PROJECT_STATUS.md` 或任务阶段要求。
- 工作区干净，或未提交修改明确属于当前任务。
- 当前任务单状态允许继续。
- 任务进度文件和 Git 状态一致。
- 没有未解决阻塞项。

### 需要人工确认

出现：

- `PROJECT_STATUS.md` 与 Git 状态不一致。
- 当前任务单仍是 `Draft`。
- 有未提交修改，但不知道是谁改的。
- 当前分支不是任务分支，也不是允许的主分支。
- 任务进度文件缺失或明显过期。
- 上一次会话在执行外部写操作时中断。

### 需要恢复现场

出现：

- 文件被部分生成。
- 安装依赖或迁移执行到一半。
- Git 合并、rebase、cherry-pick 未完成。
- 有冲突文件。
- CI/PR 状态和本地状态不一致。

## 未提交修改处理规则

发现未提交修改时，不允许直接覆盖或继续写代码。

先执行：

```powershell
git status --short
git diff --stat
git diff
```

然后判断：

- 属于当前任务且内容正确：继续或提交。
- 属于当前任务但不完整：先更新进度文件，再继续。
- 不属于当前任务：停止，等待人工确认。
- 无法判断：停止，等待 Codex 或用户评审。

## 任务进度文件规则

每个任务应有一个进度文件：

```text
tasks/TASK-XXXX.progress.md
```

它记录：

- 当前阶段。
- 已完成检查项。
- 未完成检查项。
- 最近一次会话结果。
- 下一步动作。
- 阻塞项。

任务进度文件不是替代 Git commit，而是帮助新窗口理解当前任务。

## 更新频率

必须更新进度文件的时机：

- 开始任务前。
- 实现计划被用户确认后。
- 每个稳定步骤完成后。
- 每次准备提交前。
- 每次被评审打回后。
- 每次窗口即将结束前。
- 发现阻塞时。

## 门禁优先级

恢复结果不能覆盖门禁结果。

如果 `scripts/check-task-state.ps1`、Git hooks、CI、Codex Review 任一失败，应先修复失败原因，而不是继续开发。

## Claude 接力提示词

```text
你现在是接力会话。先不要改代码。

请执行恢复流程：

1. 阅读 CLAUDE.md
2. 阅读 AGENTS.md
3. 阅读 PROJECT_STATUS.md
4. 阅读 docs/ai-workflow.md
5. 阅读 docs/resume-protocol.md
6. 阅读当前任务单
7. 阅读当前任务进度文件
8. 运行 scripts/session-snapshot.ps1

然后按恢复报告格式输出当前状态。

没有我确认前，不要修改任何文件。
```

## Codex 接力提示词

```text
请先不要修改文件。

请按 docs/resume-protocol.md 执行恢复检查，并输出恢复报告。
如果发现未提交修改、任务状态不一致、分支不一致或任务进度缺失，请停止并说明风险。
```
