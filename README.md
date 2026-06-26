# zaiwangEC

视频复刻 AI Agent 平台重构项目。

当前仓库先落地 AI 协作开发治理骨架，用于验证：

- Claude 按任务单开发。
- Codex 按固定标准审查。
- GitHub PR 承载任务上下文。
- CI 做基础门禁。
- 窗口中断后可以通过项目状态文件恢复。

## 当前阶段

```text
PREPARE_AI_WORKFLOW
```

第一阶段不直接开发完整业务，先通过 `tasks/TASK-0001.md` 验证最小闭环。

## 开发前必须阅读

1. `CLAUDE.md`
2. `AGENTS.md`
3. `PROJECT_STATUS.md`
4. `docs/ai-workflow.md`
5. `docs/resume-protocol.md`
6. 当前任务单
7. 当前任务进度文件

## 目录说明

| 路径 | 用途 |
|---|---|
| `CLAUDE.md` | Claude 开发规则 |
| `AGENTS.md` | Codex 审查规则 |
| `PROJECT_STATUS.md` | 当前任务状态和中断恢复 |
| `docs/` | 架构、流程、评审标准、技术选型文档 |
| `tasks/` | 任务单 |
| `tasks/*.progress.md` | 任务细粒度进度和接力状态 |
| `reviews/` | 评审记录 |
| `.github/` | PR 模板、Issue 模板、CI |
| `scripts/` | 自动检查脚本 |

## 本地检查

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-ai-governance.ps1
```

## 会话快照

Claude、Codex 或人工接力前，先运行：

```powershell
powershell -ExecutionPolicy Bypass -File scripts\session-snapshot.ps1
```
