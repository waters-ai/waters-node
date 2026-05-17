# WATERS Node v0.4 — Technical Specification

**Версия:** 0.4 | **Дата:** 2026-05-17 | **Автор:** agent.constructor.v1

---

## WATNODE-ARCH: Node Architecture

### WATNODE-ARCH-1: Node Core

Single 11MB binary, 36 .rs files, ~9500 lines of Rust code. Node includes SubAgent Manager (max 10 concurrent), BridgeProvider (LLM, MCP, media, voice, chat), P2P Gossip (mDNS + TCP), web dashboard (SSE).

> **Следствие:** Node runs without external dependencies except Redis

### WATNODE-ARCH-2: Node Layers

UX layer: chat + voice. Core layer: Engine with command routing. Resource layer: Bridge Registry, MCP Client Pool, Skill Registry. Network layer: P2P + Gossip + WAL. Autonomy layer: L0-L4 + DTN.

> **Следствие:** Each layer is isolated and can be replaced independently

### WATNODE-ARCH-3: Comparison with Hermes Agent

Hermes Agent (153K ★) is a mature platform with self-improving skills, 22 messaging platforms, cron scheduler, lazy dependency loading, and plugins. waters-node is more compact (11MB vs ~200MB), faster (Rust vs Python), but lags in skill ecosystem and multi-platform support.

> **Следствие:** v0.5 should add skill self-improvement, cron, and more platforms

---

## WATNODE-MODE: Node Modes

### WATNODE-MODE-1: Five Operating Modes

Plan — task planning and goal setting. Assemble — group assembly (nodes + agents). Execute — task execution, agents working. Stop — pause all tasks. Log — group work log. Switch: режим план/сбор/выполнение/стоп/журнал.

> **Следствие:** Modes determine available commands and agent behavior

---

## WATNODE-MEM: Memory System (Redis)

### WATNODE-MEM-1: Multi-DB Architecture

DB 0 — system (node:state, rating, security). DB 1-6 — groups (chat, findings, journal, opinions). DB 15 — LLM cache. Keys: agent:{id}:state (Hash), agent:{id}:findings (Stream), group:{id}:chat (Stream).

> **Следствие:** Data survives restarts, Redis is the only mandatory dependency

---

## WATNODE-P2P: Network (P2P)

### WATNODE-P2P-1: Connection Topology

Up to 6 peers (MAX_PEERS=6). Master-slave (one behind NAT), Hub-and-Spoke (all through VPS), full mesh (6 nodes). mDNS for local discovery, TCP sync for WAL. DTN for intermittent connectivity.

> **Следствие:** Each node has HTTP API (port N), MCP server (N+100), TCP sync (N+3), mDNS (N+1)

---

## WATNODE-AGENT: Agent System

### WATNODE-AGENT-1: SubAgent Lifecycle

agent_open(role, skill, llm) → spawn tokio task. agent_send_input(message, interrupt) → send message. agent_assign(new_objective) → change task. agent_eval → read results. agent_close → cancellation cascade + journal. Concurrency cap: max 10.

> **Следствие:** Agents can work in parallel, be imported from TUI/Claude/Cursor, and be merged

### WATNODE-AGENT-2: 54+ Professions

TUI-code agents (general, explorer, planner, reviewer, implementer, verifier, custom). WATERS professions: collector, scout, analyst, synthesizer, coordinator, archivist, specialist. Media: camera-operator, video-editor, lab-operator.

> **Следствие:** Agents can be created, imported, and merged at runtime

---

## WATNODE-SEC: Security

### WATNODE-SEC-1: YASA Screening

Every agent is screened: bridges (only allowed), prompt (rm -rf, sudo, curl|bash), imported_from (only trusted). Chat-approve connections. Heartbeat monitoring. Rating < 0.3 gets no tasks. Autonomy L0-L4.

> **Следствие:** Security at agent launch level, not network level

---

## WATNODE-API: API and Commands

### WATNODE-API-1: HTTP API

GET /status — node state. GET /peers — peer list. POST /chat — send message. GET /store/:key — Redis read. SSE /api/v1/stream/{session} — streaming. MCP server on port N+100.

> **Следствие:** Full node functionality access via HTTP

### WATNODE-API-2: Chat Commands

/help — help. /skills — skill list. /agents — agent list. /bridges — bridge list. /status — state. /mode — switch mode. /connect <ip> — connect peer. /chat <text> — LLM. /say <id> <text> — group message. /merge — merge agents. /import — import agent.

> **Следствие:** All commands available in Russian and via web dashboard

---

## WATNODE-INSTALL: Installation and Launch

### WATNODE-INSTALL-1: Quick Start

Linux: download binary + Redis + DeepSeek API key. Windows: powershell + Memurai. Docker: redis + waters-node containers. VPS: ssh + binary. Minimum requirements: Redis 6+, DeepSeek API/Ollama, Chrome 90+ browser.

> **Следствие:** From 5 minutes to first node launch
