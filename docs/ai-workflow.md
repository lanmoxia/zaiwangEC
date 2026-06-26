# AI 协作开发流程

本文件定义 Claude、Codex、GitHub、CI 如何协作。目标是降低窗口中断、模型遗忘、范围漂移、人工看不懂代码带来的风险。

## 核心原则

1. GitHub / Git / 任务单 / CI 是事实来源，聊天记忆不是事实来源。
2. 一个任务对应一个任务单、一个分支、一个 PR。
3. 没有 `Approved` 任务单，不允许编码。
4. Claude 负责实现，Codex 负责评审，用户负责批准范围和最终合并。
5. 任何 AI 不确定时，必须标记 `NEEDS_HUMAN`，不能猜。
6. 新 commit 会使旧评审失效，需要重新评审最新 commit。
7. 未解决 `P0` / `P1`、CI 失败、任务范围不清时，不得合并。

## 文件分工

| 文件 | 用途 |
|---|---|
| `CLAUDE.md` | Claude 开发强制规则 |
| `AGENTS.md` | Codex 评审强制规则 |
| `PROJECT_STATUS.md` | 当前任务和中断恢复状态 |
| `tasks/TASK_TEMPLATE.md` | 任务单模板 |
| `tasks/TASK-XXXX.progress.md` | 单个任务的细粒度进度与接力状态 |
| `docs/resume-protocol.md` | 会话中断、跨设备、换窗口后的恢复协议 |
| `docs/codex-review-standard.md` | Codex 详细评审清单 |
| `.github/pull_request_template.md` | PR 必填信息 |
| `.github/ISSUE_TEMPLATE/task.yml` | GitHub 任务创建模板 |
| `reviews/REVIEW_TEMPLATE.md` | 人工或 Codex 评审记录模板 |
| `scripts/session-snapshot.ps1` | 一键输出当前分支、commit、工作区、任务状态 |

## 标准流程

```text
创建任务单
↓
用户确认任务范围和验收标准
↓
任务状态改为 Approved
↓
Claude 新建任务分支
↓
Claude 实现最小变更
↓
Claude 本地验证
↓
Claude 提交 commit 并创建 PR
↓
CI 自动检查
↓
Codex 按 AGENTS.md 和任务单评审
↓
Claude 修复问题
↓
Codex 复审最新 commit
↓
用户确认合并
```

## 任务状态

- `Draft`：草稿，不允许实现。
- `Approved`：用户批准，可开始实现。
- `In Progress`：Claude 正在实现。
- `Review`：等待 Codex 或人工评审。
- `Changes Requested`：评审打回，需要修复。
- `Done`：已合并或用户确认完成。
- `Blocked`：无法继续，需要人工决策。

## 分支命名

```text
feat/TASK-0001-short-title
fix/TASK-0002-short-title
docs/TASK-0003-short-title
```

## Commit 要求

每个 commit 必须关联任务：

```text
TASK-0001: 初始化健康检查接口
```

禁止混入无关修改。

## PR 要求

PR 必须包含：

- 关联任务单。
- 任务目标。
- 修改摘要。
- 修改文件。
- 验收标准逐条映射。
- 已运行验证命令和结果。
- 未验证项及原因。
- 风险和回滚方式。

缺少以上信息，Codex 评审结论应为 `NEEDS_HUMAN`。

## 中断恢复

新窗口接手必须先读：

1. `CLAUDE.md`
2. `AGENTS.md`
3. `PROJECT_STATUS.md`
4. `docs/resume-protocol.md`
5. 当前任务单
6. 当前任务进度文件
7. `scripts/session-snapshot.ps1` 输出
8. `git status`
9. 最近 commit

然后输出恢复报告。状态不一致时，先恢复现场，不允许继续开发。

## 高风险变更

以下变更必须单独任务、单独批准：

- 权限、登录、数据作用域。
- 数据库破坏性迁移。
- 生产外部写操作。
- Provider 真实 API 调用策略变化。
- Prompt、模型、RAG、Skill 的生产策略变化。
- 成本、限流、队列、并发策略变化。
- Evals 阈值和黄金样本变化。
- 依赖大版本升级。

## 最小落地顺序

1. 建立本文件和相关模板。
2. 用 `TASK-0001` 验证闭环。
3. 初始化项目骨架。
4. 增加基础 CI。
5. 增加 `doctor` 环境检查。
6. 再进入视频复刻业务开发。
