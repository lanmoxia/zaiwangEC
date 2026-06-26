# 项目路线图

本路线图用于防止长期开发中方向漂移。任务可以调整，但阶段顺序不得随意跳跃。

## Phase 0：AI 开发治理底座

目标：先让 Claude、Codex、GitHub、CI、Git hooks 可以稳定协作。

必须完成：

- [x] 仓库级 Claude 开发规则。
- [x] 仓库级 Codex 评审规则。
- [x] 任务单模板。
- [x] PR 模板。
- [x] 中断恢复协议。
- [x] 会话快照脚本。
- [ ] 任务开工门禁。
- [ ] 本地 Git hooks。
- [ ] PR/CI 增强门禁。
- [ ] GitHub main 分支保护。

## Phase 1：最小项目骨架

目标：证明项目可以被稳定开发、测试、审查、恢复。

必须完成：

- [ ] 前后端或 API 最小骨架。
- [ ] 健康检查能力。
- [ ] 本地启动命令。
- [ ] 基础测试命令。
- [ ] GitHub Actions 通过。
- [ ] Codex 完成一次 PR 评审。

## Phase 2：视频复刻核心数据契约

目标：先固定结构化数据和版本，不急着接真实外部平台。

必须完成：

- [ ] VideoSpec Schema。
- [ ] ShotPlan Schema。
- [ ] StoryboardSpec Schema。
- [ ] PromptVersion Schema。
- [ ] Provider Adapter 契约。
- [ ] 人工评审与反馈数据模型草案。

## Phase 3：内部 50 人平台 MVP

目标：多用户、任务队列、素材、反馈隔离先跑通。

必须完成：

- [ ] 用户/团队/项目作用域。
- [ ] 上传素材与任务创建。
- [ ] 异步任务状态。
- [ ] 人工评审页面。
- [ ] 反馈记录和版本追踪。
- [ ] 基础权限测试。

## Phase 4：Agent 工作流接入

目标：受控接入 AI 分析、分镜、故事板和提示词生成。

必须完成：

- [ ] Qwen 视觉分析 Adapter。
- [ ] Claude Prompt 编译节点。
- [ ] 豆包 Provider 策略。
- [ ] 可灵 Provider 策略。
- [ ] libTv Storyboard Adapter。
- [ ] Agent Evals 和 Trace。

## Phase 5：知识库与学习闭环

目标：反馈和好案例可审查、可晋升、可回滚。

必须完成：

- [ ] 个人反馈与团队知识隔离。
- [ ] 知识候选机制。
- [ ] 人工审核晋升。
- [ ] RAG 检索日志。
- [ ] 知识版本和回滚。

## 禁止跳跃

- 没有 Phase 0，不进入长期业务开发。
- 没有 Phase 1，不接复杂 Agent。
- 没有结构化 Schema，不做 RAG/记忆/自进化。
- 没有权限隔离，不给 50 人团队试用。
