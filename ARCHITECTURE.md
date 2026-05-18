# Архитектура waters-node v1.0.0 / Architecture / 架构

## 1. [RU] Ядро (Rust) — 48+ модулей

```
waters-node/
├── hybrid_llm.rs      — 🔴 EdgeEngine (GGUF), SwitchProtocol (L0-L4)
├── distributed.rs     — 🔴 DistributedCache, PipelineParallel, TokenFed
├── code_review.rs     — 🔴 3 агента, CodeSandbox, голосование
├── bridge.rs          — ✅ BridgePool: LLM, Chat, Voice, MCP, Media
├── gossip.rs          — ✅ P2P: mDNS + TCP sync + Cargo protocol
├── cargo.rs           — ✅ DTN-перемещение агентов
├── dtn.rs             — ✅ DTN-задержки, приоритетная очередь
├── store.rs           — ✅ Redis multi-DB (0-15)
├── subagent.rs        — ✅ SubAgent lifecycle (open/eval/close)
├── autonomy.rs        — ✅ L0-L4 + can_use_edge()
├── offline.rs         — ✅ OfflineQueue (JSONL)
├── yasa_agent.rs      — ✅ +CMD-6: проверка бортовой LLM
├── self_deploy.rs     — ✅ +deploy_with_review()
├── a2a.rs             — ✅ Google Agent2Agent (не трогать)
├── mcp_store.rs       — ✅ MCP Store (не трогать)
├── media_bridge.rs    — ✅ NDI, OBS, RTMP (не трогать)
├── tamagotchi.rs      — ✅ Личность ноды (не трогать)
├── agent.rs, task.rs, group.rs, session.rs, channel.rs ...
└── main.rs            — ✅ +HybridLlm.init()
```

## 2. [RU] Память (Redis) — расширение v1.0.0

```
DB 0  — системная: node:state, agent:rating, security
DB 1-6 — группы: group:{id}:chat, findings, journal
DB 14 — EDGE_CACHE: кеш бортовой LLM (TTL 300s)   ← NEW
DB 15 — LLM_CACHE: кеш внешней LLM (TTL 60s)
DB 16 — DISTR_CACHE: распределённый кеш 6 нод      ← NEW
```

## 3. [RU] Сеть (P2P)

```
mDNS — обнаружение нод в локальной сети
TCP  — синхронизация каналов (WAL)
DTN  — прерывистая связь, пакеты 256 байт

Порты:
  HTTP API: N
  MCP Server: N+100
  TCP sync: N+3
  mDNS: N+1
```

## 4. [RU] Гибридная LLM (новое в v1.0.0)

```
Agent → HybridLlm.query(prompt, Auto)
  ├── RemoteRouter → BridgePool (DeepSeek/Ollama/OpenAI...)
  ├── EdgeEngine → llama-cpp-rs (GGUF 1-3B, CPU)
  ├── SwitchProtocol → AutonomyEngine (L0-L4)
  ├── PrefetchCache → Redis DB 14
  └── SyncQueue → OfflineQueue (JSONL)
```

## 5. [RU] Распределённый инференс (новое в v1.0.0)

```
6 нод P2P:
  DistributedCache: hash(prompt) → gossip → 200ms
  PipelineParallel: модель по слоям, тензоры через CargoEngine
  TokenFederation: DeepSeek Flash API → пул → автономия
  DomainRouter: ProfileConfig → роутинг по доменам
```

## 6. [RU] Безопасный self-improve (новое в v1.0.0)

```
3 агента:
  Programmer — пишет код + тесты
  SecurityReviewer — YASA + OWASP
  OnboardManager — RAM/CPU/compat
Голосование: 2/3 Approve → AutoDeploy
CodeSandbox: tempfile + unshare/docker
```

## 7. [RU] Сравнение v0.5 vs v1.0.0

| Параметр | v0.5 | v1.0.0 |
|----------|------|--------|
| Объём кода | ~12000 строк | ~15000 строк |
| Модулей | 48 | 51+ |
| LLM-режим | Online only | Online + GGUF + P2P |
| Self-improve | без ревью | 3-агентный конвейер |
| Офлайн | L4 safe mode | L2-L4 с EdgeEngine |
| Бинарник | 12MB | <20MB (GGUF отдельно) |
| Тестов | 36 | 40+ |

## [EN] Key changes in v1.0.0

Three new modules: `hybrid_llm.rs`, `distributed.rs`, `code_review.rs`.
Extended Redis: DB 14 (edge cache), DB 16 (distributed cache).
YASA CMD-6 added. Self-deploy with code review pipeline.

## [ZH] v1.0.0 的主要变化

三个新模块：`hybrid_llm.rs`、`distributed.rs`、`code_review.rs`。
扩展的Redis：DB 14（边缘缓存）、DB 16（分布式缓存）。
新增YASA CMD-6。带代码审查管道的自我部署。

---

*Обновлено для v1.0.0. Три языка: RU, EN, ZH.*
