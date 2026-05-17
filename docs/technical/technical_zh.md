# WATERS Node v0.4 — 技术规范

**Версия:** 0.4 | **Дата:** 2026-05-17 | **Автор:** agent.constructor.v1

---

## WATNODE-ARCH: 节点架构

### WATNODE-ARCH-1: 节点核心

单个 11MB 二进制文件，36 个 .rs 文件，约 9500 行 Rust 代码。节点包括 SubAgent 管理器（最多 10 个并发）、BridgeProvider（LLM、MCP、媒体、语音、聊天）、P2P Gossip（mDNS + TCP）、网页仪表板（SSE）。

> **Следствие:** 节点除 Redis 外无需外部依赖即可运行

### WATNODE-ARCH-2: 节点层次

UX 层：聊天 + 语音。核心层：带命令路由的引擎。资源层：桥接注册表、MCP 客户端池、技能注册表。网络层：P2P + Gossip + WAL。自治层：L0-L4 + DTN。

> **Следствие:** 每层都是独立的，可以独立更换

### WATNODE-ARCH-3: 与 Hermes Agent 的比较

Hermes Agent（153K ★）是一个成熟的平台，具有自我改进技能、22 个消息平台、cron 调度器、延迟依赖加载和插件。waters-node 更紧凑（11MB 对比 ~200MB），更快（Rust 对比 Python），但在技能生态系统和多平台支持方面落后。

> **Следствие:** v0.5 应添加技能自我改进、cron 和更多平台

---

## WATNODE-MODE: 节点模式

### WATNODE-MODE-1: 五种操作模式

Plan — 任务规划和目标设定。Assemble — 组装配（节点 + 智能体）。Execute — 任务执行，智能体工作。Stop — 暂停所有任务。Log — 组工作日志。切换：режим план/сбор/выполнение/стоп/журнал。

> **Следствие:** 模式决定了可用的命令和智能体行为

---

## WATNODE-MEM: 内存系统（Redis）

### WATNODE-MEM-1: 多数据库架构

DB 0 — 系统（node:state、评分、安全）。DB 1-6 — 组（聊天、发现、日志、意见）。DB 15 — LLM 缓存。键：agent:{id}:state（Hash）、agent:{id}:findings（Stream）、group:{id}:chat（Stream）。

> **Следствие:** 数据在重启后仍然存在，Redis 是唯一强制依赖

---

## WATNODE-P2P: 网络（P2P）

### WATNODE-P2P-1: 连接拓扑

最多 6 个对等点（MAX_PEERS=6）。主从（一个在 NAT 后）、集线辐射（全部通过 VPS）、全网状（6 个节点）。mDNS 用于本地发现，TCP sync 用于 WAL。DTN 用于间歇性连接。

> **Следствие:** 每个节点都有 HTTP API（端口 N）、MCP 服务器（N+100）、TCP sync（N+3）、mDNS（N+1）

---

## WATNODE-AGENT: 智能体系统

### WATNODE-AGENT-1: 子智能体生命周期

agent_open(role, skill, llm) → 生成 tokio 任务。agent_send_input(message, interrupt) → 发送消息。agent_assign(new_objective) → 更改任务。agent_eval → 读取结果。agent_close → 取消级联 + 日志。并发上限：最多 10 个。

> **Следствие:** 智能体可以并行工作，从 TUI/Claude/Cursor 导入，并可合并

### WATNODE-AGENT-2: 54+ 职业

TUI-code 智能体（通用、探索者、规划者、审查者、实现者、验证者、自定义）。WATERS 职业：收集者、侦察者、分析者、合成者、协调者、档案员、专家。媒体：摄像操作员、视频编辑员、实验室操作员。

> **Следствие:** 智能体可以在运行时创建、导入和合并

---

## WATNODE-SEC: 安全

### WATNODE-SEC-1: YASA 审查

每个智能体都经过审查：桥接（仅允许的）、提示（rm -rf、sudo、curl|bash）、imported_from（仅受信任的）。聊天批准连接。心跳监控。评分 < 0.3 不会获得任务。自主性 L0-L4。

> **Следствие:** 安全在智能体启动级别，而非网络级别

---

## WATNODE-API: API 和命令

### WATNODE-API-1: HTTP API

GET /status — 节点状态。GET /peers — 对等列表。POST /chat — 发送消息。GET /store/:key — Redis 读取。SSE /api/v1/stream/{session} — 流式传输。MCP 服务器在端口 N+100。

> **Следствие:** 通过 HTTP 完全访问节点功能

### WATNODE-API-2: 聊天命令

/help — 帮助。 /skills — 技能列表。 /agents — 智能体列表。 /bridges — 桥接列表。 /status — 状态。 /mode — 切换模式。 /connect <ip> — 连接对等。 /chat <text> — LLM。 /say <id> <text> — 群组消息。 /merge — 合并智能体。 /import — 导入智能体。

> **Следствие:** 所有命令均可使用俄语并通过网页仪表板使用

---

## WATNODE-INSTALL: 安装和启动

### WATNODE-INSTALL-1: 快速开始

Linux：下载二进制文件 + Redis + DeepSeek API 密钥。Windows：powershell + Memurai。Docker：redis + waters-node 容器。VPS：ssh + 二进制文件。最低要求：Redis 6+、DeepSeek API/Ollama、Chrome 90+ 浏览器。

> **Следствие:** 从 5 分钟到第一个节点启动
