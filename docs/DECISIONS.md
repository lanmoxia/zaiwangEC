# 决策索引

本文件记录项目长期有效的关键工程决策。详细内容可放入 ADR，索引用于新窗口快速理解当前原则。

## 已接受决策

### DEC-0001：Git / GitHub / CI / 任务单是事实来源

聊天记录不是事实来源。任何恢复、评审、继续开发，都必须先读仓库文件和 Git 状态。

相关文件：

- `PROJECT_STATUS.md`
- `docs/resume-protocol.md`
- `scripts/session-snapshot.ps1`

### DEC-0002：一个任务对应一个任务单、一个分支、一个 PR

长期开发不允许多个需求混在一个 PR 中。

例外：Phase 0 bootstrap 阶段可直接在 `main` 上补治理文件，但完成后应启用分支保护。

### DEC-0003：AI 可以忘记规则，但系统不能放行违规操作

长期治理依赖硬门禁：

- 开工门禁。
- Git hooks。
- PR/CI 门禁。
- GitHub 分支保护。
- Codex 逻辑审查。

### DEC-0004：Claude 是实现者，Codex 是审查者

Claude 默认不做最终审批。Codex 默认不顺手改代码，除非用户明确要求修复。

### DEC-0005：视频复刻业务先做结构化契约，再做复杂 Agent

优先固定：

- VideoSpec
- ShotPlan
- StoryboardSpec
- PromptVersion
- Provider Adapter

RAG、动态 Skill、多 Agent、模型自进化属于后续阶段，不进入早期主链路。

## 待确认决策

- 是否使用远程开发服务器作为长期统一开发环境。
- 第一版项目骨架技术栈。
- GitHub main 分支保护具体规则。
- CI 中是否要求所有 PR 必须经过 Codex Review。
