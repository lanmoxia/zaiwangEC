# Claude项目指令

本文件只包含项目级强制规则。具体业务和架构以链接文档为准。

## 开始任何实现之前

1. 阅读[AI协作开发流程](./docs/ai-workflow.md)。
2. 阅读[项目状态](./PROJECT_STATUS.md)并确认当前任务。
3. 阅读当前经批准的任务单。
4. 阅读任务引用的ADR和契约。
5. 阅读当前任务进度文件。
6. 运行 `scripts/session-snapshot.ps1`。
7. 运行 `scripts/check-task-state.ps1 -TaskId TASK-XXXX -Mode Start`。
8. 阅读[视频复刻AI平台重构设计](./docs/video-replication-platform-design.md)。
9. 遵循[Claude开发与审核规范](./docs/claude-development-review-guide.md)。
10. 将[Agent技术应用与选型参考](./docs/agent-tech-selection-guide.md)仅作为候选技术手册，不得据此自行增加技术。

## 新窗口或中断恢复

任何新窗口接手时，先不要改代码。必须先完成：

1. 阅读 `PROJECT_STATUS.md`。
2. 阅读当前任务单。
3. 阅读当前任务进度文件，例如 `tasks/TASK-0001.progress.md`。
4. 阅读 `docs/resume-protocol.md`。
5. 运行 `scripts/session-snapshot.ps1`。
6. 输出恢复报告。
7. 如果状态不一致，停止并请求人工确认。

## 强制规则

- 没有任务编号、范围和验收标准时，不开始编码。
- 任务单状态不是 `Approved` 或 `In Progress` 时，不开始编码。
- Draft任务只能讨论和完善，不允许实现。
- 开发新任务前必须通过 `scripts/start-task.ps1` 或 `scripts/check-task-state.ps1`。
- 未被Accepted ADR选择的重大技术不得进入生产实现。
- 保持最小变更，禁止无关重构。
- 一个任务只允许一个分支和一个PR；不得混入其他任务。
- 任务开始、稳定提交、阻塞时必须更新 `PROJECT_STATUS.md` 和当前任务进度文件。
- 安装 Git hooks 后，不得绕过 hooks；如果 hooks 失败，修复原因而不是跳过检查。
- 不得直接 push `main` 开发业务功能；Phase 0 bootstrap 例外结束后必须走 PR。
- 所有多用户数据访问必须执行服务端作用域校验。
- 所有AI节点使用版本化、结构化输入输出。
- 所有长任务异步化，并定义超时、重试、幂等、取消和失败状态。
- Prompt、模型、Skill、RAG索引和工具契约的变化必须版本化。
- 未审核反馈不得进入团队或公司知识库。
- 豆包与可灵故事板共用版本化StoryboardSpec；Provider差异通过Adapter实现。
- 豆包生成的是完整镜头/场景级素描故事板，不是单角色素描肖像，并且不使用可识别真人脸；可灵真实角色素材必须有授权、作用域和审计记录。
- 未通过测试、权限检查、Evals和Diff审核的变更不得宣称完成。
- 数据库迁移、依赖变更、权限变更、生产外部写操作必须单独请求批准。
- 不读取、打印或提交生产密钥和真实敏感数据。

## 完成任务时必须报告

- 修改文件。
- 需求/ADR到代码与测试的映射。
- 实际执行的验证命令和结果。
- 未执行的验证及原因。
- 已知风险和回滚方式。
- `scripts/session-snapshot.ps1` 输出是否正常。
- Git hooks / CI / PR 门禁是否通过。
