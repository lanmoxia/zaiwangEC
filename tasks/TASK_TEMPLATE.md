# TASK-XXXX：任务标题

> 状态：Draft / Approved / In Progress / Review / Changes Requested / Done / Blocked  
> 创建人：  
> Implementer：  
> Reviewer：  
> 关联需求：  
> 关联ADR：  

## 1. 目标

用一至三句话说明本任务完成后新增或改变的可观察行为。

## 2. 背景

说明为什么需要该变更，以及它位于哪个业务流程。

## 3. 范围

### 必须完成

- [ ]

### 明确不做

- [ ]

### 允许修改

- `path/to/module`

### 禁止修改

- `path/to/unrelated-module`

## 4. 输入输出契约

### 输入

```text
Schema、版本、来源、权限要求
```

### 输出

```text
Schema、版本、错误类型、副作用
```

## 5. 数据与权限影响

- Workspace/Team/Project/User作用域：
- 是否涉及对象存储：
- 是否涉及故事板、libTv或Provider渲染策略：
- 是否涉及可识别人脸/真实角色授权：
- 故事板是完整镜头面板还是角色素材（默认必须明确）：
- 是否涉及RAG或记忆：
- 是否涉及数据库迁移：
- 是否涉及敏感数据：

## 6. 外部调用与可靠性

- Provider/Tool：
- 超时：
- 重试条件：
- 最大尝试次数：
- 幂等键：
- 取消/补偿方式：
- 成本或步骤预算：

## 7. 验收标准

- [ ] 正常路径：
- [ ] 失败路径：
- [ ] 权限隔离：
- [ ] 并发/幂等：
- [ ] Trace/审计：
- [ ] Evals或业务指标：

## 8. 验证命令

```text
待项目脚手架建立后填写真实命令
```

## 9. 回滚方案

说明代码、配置、数据和外部副作用如何回滚。

## 10. 完成证据

### 修改文件

-

### 需求/ADR → 代码

| 要求 | 实现位置 |
|---|---|
| | |

### 需求/ADR → 测试

| 要求 | 测试位置 |
|---|---|
| | |

### 实际验证结果

```text
命令、结果、未运行项及原因
```

### 已知风险

-

## 11. Reviewer结论

- [ ] 需求完整
- [ ] 未超出范围
- [ ] ADR与契约一致
- [ ] 测试覆盖有效
- [ ] 多用户作用域安全
- [ ] 可回滚

结论：Approve / Request Changes

## 12. 状态更新要求

任务状态变化时，必须同步更新 `PROJECT_STATUS.md`：

- 开始任务：更新 `current_task`、`current_task_file`、`current_branch`、`current_step`。
- 稳定提交：更新 `last_good_commit`。
- 中断前：更新 `current_step` 和 `next_action`。
- 阻塞时：设置 `blocked: true` 并写明原因。
