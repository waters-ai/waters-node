# Архитектура waters-node v0.4

## 1. Ядро (Rust)

**Один бинарник, 11MB, 36 .rs файлов, ~9500 строк кода.**

```
waters-node
├── main.rs           — точка входа, инициализация
├── store.rs          — Redis multi-DB (0-15), PUBLISH, XADD, HSET
├── subagent.rs       — SubAgent lifecycle (open/eval/close/send/assign)
├── bridge.rs         — BridgeProvider: LLM, Chat, Voice, MCP, Media
├── skill.rs          — SkillRegistry, SkillManifest, merge_agents
├── bridge_agent.rs   — импорт/экспорт TUI/Claude/Cursor/WATERS
├── agent_rating.rs   — рейтинг + YASA-досмотр безопасности
├── group_chat.rs     — групповой чат + мнения агентов о задачах
├── media_bridge.rs   — NDI, OBS, RTMP, HDMI
├── mcp_server.rs     — MCP-сервер (агенты как tools для внешних систем)
├── mcp.rs            — MCP-клиент
├── gossip.rs         — P2P: mDNS + TCP sync
├── group.rs          — группы, режимы, участники
├── channel.rs        — WAL-каналы
├── cargo.rs          — протокол передачи агентов
├── api.rs            — HTTP API + веб-дашборд (+ голос)
├── tui_agent.rs      — TUI-совместимые агенты
├── handlers.rs       — CLI-команды (/agent, /say, /send, /merge...)
├── session.rs        — сессии, checkpoint recovery
├── convo.rs          — диалоговый интерфейс
├── display.rs        — ANSI-вывод
├── tools/            — инструменты (file, search, shell, git)
├── task.rs           — менеджер задач
├── config.rs         — TOML-конфиг
├── node.rs           — идентификация ноды
├── agent.rs          — реестр агентов
├── autonomy.rs       — L0-L4 автономия
├── dtn.rs            — DTN-задержки (tc-netem)
├── journal.rs        — бортовой журнал
├── offline.rs        — офлайн-очередь
├── mode.rs           — режимы ноды
└── demo.rs           — демо-режим
```

## 2. Память (Redis)

Каждая нода использует локальный Redis (или удалённый).

```
DB 0  — системная: node:state, agent:rating:*, agent:security:*
DB 1-6 — группы: group:{id}:chat, findings, journal
DB 15 — LLM cache: llm:{name}:{hash}

Ключи:
  agent:{id}:state        → Hash — состояние агента
  agent:{id}:findings     → Stream — результаты работы
  agent:{id}:journal      → Stream — жизненный цикл
  agents:active           → Set — активные агенты
  group:{id}:chat         → Stream — чат группы
  group:{id}:opinions:{t} → Stream — мнения о задаче
  media:ndi:{source}      → Stream — NDI видеокадры
  media:display:latest    → Stream — последнее на экран
  studio:capture:{source} → Stream — захват из студии
```

## 3. Сеть (P2P)

Ноды общаются через gossip протокол:

```
mDNS — обнаружение нод в локальной сети
TCP  — синхронизация каналов (WAL)
      ─ сообщения, задачи, состояния агентов
      
Каждая нода:
  - HTTP API на порту N (web dashboard)
  - MCP Server на порту N+100 (agents as tools)
  - TCP sync на порту N+3
  - mDNS на порту N+1
```

## 4. Агенты

```
agent_open(role, skill, llm, group_id, node_id, parent_id, bg)
  → создаёт Redis Hash + Stream
  → spawn tokio task (слушает input)
  → проверка concurrency cap (max 10)

agent_send_input(agent_id, message, interrupt)
  → отправляет сообщение в канал агента

agent_assign(agent_id, new_objective)
  → обновляет задачу в Redis

agent_eval(agent_id) → SubAgentResult
  → читает state + findings_count из Redis

agent_close(agent_id)
  → cancellation cascade (закрывает детей)
  → сохраняет journal
```

## 5. Медиа-мосты

```
MediaBridge:
  NDI    — отправка видео по сети (Redis → NDI)
  OBS    — управление сценами через WebSocket
  RTMP   — стриминг на YouTube/Twitch
  HDMI   — вывод на экран (SDL2/framebuffer)

Audio:
  🎤 Рация    — MediaRecorder → SSE → AudioContext (0 токенов)
  🤖 Агент    — SpeechRecognition → LLM → SpeechSynthesis (токены)
  6 голосов   — разные профили для разных агентов
```

## 6. Безопасность (YASA)

```
/screen <agent> → досмотр:
  1. Проверка bridges (только разрешённые)
  2. Сканирование prompt (rm -rf, sudo, curl|bash...)
  3. Проверка imported_from (только trusted источники)
  4. Если fail → блокировка запуска
```



## 8. Режимы ноды

Пять режимов определяют состояние группы:

| Режим | Описание | Доступные команды |
|-------|----------|-------------------|
| 📋 **Plan** | Планирование задач, определение целей | создай задачу, покажи задачи, режим сбор |
| 🔗 **Assemble** | Сбор группы: подключение нод, агентов | подключись к, добавь агента, создай группу, режим выполнение |
| ⚡ **Execute** | Исполнение: агенты работают | назначь, покажи статус, стоп задача |
| ⏹ **Stop** | Пауза всех задач | продолжить, покажи статус, режим выполнение |
| 📜 **Log** | Журнал работы группы | покажи лог, режим план |

Переключение: `режим план` / `режим сбор` / `режим выполнение` / `режим стоп` / `режим журнал`

## 9. Автономия L0-L4

Уровни автономии для прерывистой связи (полевые условия, туризм):

| Уровень | LLM | Связь | Режим работы |
|---------|-----|-------|-------------|
| L0 | DeepSeek API | Онлайн | Полная функциональность |
| L1 | DeepSeek API + кэш | Эпизодическая | Экономия трафика |
| L2 | Ollama local | Офлайн | Локальная работа |
| L3 | Convo (без LLM) | Разрывы | Кризисный режим |
| L4 | Safe mode (0 LLM) | Нет | Безопасное хранение |

## 7. Сравнение с TUI

| Параметр | TUI | WATERS |
|----------|-----|--------|
| Размер | ~30MB | 11MB |
| Зависимости | Rust/npm | Только Redis |
| UI | ratatui | Веб + голос + Telegram |
| LLM | DeepSeek | 6 любых |
| Агенты | 7 (код) | 25+ (профессии) |
| Сеть | localhost | P2P |
| Голос | ❌ | ✅ |
| Медиа | ❌ | NDI/OBS/HDMI |
| Импорт | ❌ | TUI/Claude/Cursor |
