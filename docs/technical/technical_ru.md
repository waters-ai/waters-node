# WATERS Node v0.4 — Техническая спецификация

**Версия:** 0.4 | **Дата:** 2026-05-17 | **Автор:** agent.constructor.v1

---

## WATNODE-ARCH: Архитектура ноды

### WATNODE-ARCH-1: Ядро ноды

Один бинарник 11MB, 36 .rs файлов, ~9500 строк кода на Rust. Нода включает SubAgent Manager (макс 10 конкурентных), BridgeProvider (LLM, MCP, медиа, голос, чат), P2P Gossip (mDNS + TCP), веб-дашборд (SSE).

> **Следствие:** Нода работает без внешних зависимостей кроме Redis

### WATNODE-ARCH-2: Слои ноды

Слой UX: чат + голос. Слой ядра: Engine с роутингом команд. Слой ресурсов: Bridge Registry, MCP Client Pool, Skill Registry. Слой сети: P2P + Gossip + WAL. Слой автономии: L0-L4 + DTN.

> **Следствие:** Каждый слой изолирован и может быть заменён независимо

### WATNODE-ARCH-3: Сравнение с Hermes Agent

Hermes Agent (153K ★) — зрелая платформа с самосовершенствующимися навыками, 22 платформами обмена сообщениями, крон-планировщиком, ленивой загрузкой зависимостей и плагинами. waters-node компактнее (11MB vs ~200MB), быстрее (Rust vs Python), но уступает в экосистеме навыков и мультиплатформенности.

> **Следствие:** v0.5 должен добавить самосовершенствование навыков, крон и больше платформ

---

## WATNODE-MODE: Режимы ноды

### WATNODE-MODE-1: Пять режимов работы

Plan — планирование задач и целей. Assemble — сбор группы (ноды + агенты). Execute — исполнение задач, агенты в работе. Stop — пауза всех задач. Log — журнал работы группы. Переключение: режим план/сбор/выполнение/стоп/журнал.

> **Следствие:** Режимы определяют набор доступных команд и поведение агентов

---

## WATNODE-MEM: Система памяти (Redis)

### WATNODE-MEM-1: Multi-DB архитектура

DB 0 — системная (node:state, рейтинг, безопасность). DB 1-6 — группы (чат, findings, журнал, мнения). DB 15 — кэш LLM. Ключи: agent:{id}:state (Hash), agent:{id}:findings (Stream), group:{id}:chat (Stream).

> **Следствие:** Данные переживают перезапуск, Redis — единственная обязательная зависимость

---

## WATNODE-P2P: Сеть (P2P)

### WATNODE-P2P-1: Топология соединений

До 6 пиров (MAX_PEERS=6). Мастер-слейв (один за NAT), Hub-and-Spoke (все через VPS), полная сетка (6 нод mesh). mDNS для локального обнаружения, TCP sync для WAL. DTN для прерывистой связи.

> **Следствие:** Каждая нода имеет HTTP API (порт N), MCP сервер (N+100), TCP sync (N+3), mDNS (N+1)

---

## WATNODE-AGENT: Система агентов

### WATNODE-AGENT-1: SubAgent lifecycle

agent_open(role, skill, llm) → spawn tokio task. agent_send_input(message, interrupt) → отправка сообщения. agent_assign(new_objective) → смена задачи. agent_eval → чтение результатов. agent_close → cancellation cascade + journal. Concurrency cap: макс 10.

> **Следствие:** Агенты могут работать параллельно, импортироваться из TUI/Claude/Cursor и сливаться

### WATNODE-AGENT-2: 54+ профессий

TUI-code агенты (general, explorer, planner, reviewer, implementer, verifier, custom). WATERS профессии: collector, scout, analyst, synthesizer, coordinator, archivist, specialist. Медиа: camera-operator, video-editor, lab-operator.

> **Следствие:** Агенты могут быть созданы, импортированы и слиты в runtime

---

## WATNODE-SEC: Безопасность

### WATNODE-SEC-1: YASA-досмотр

Каждый агент проверяется: bridges (только разрешённые), prompt (rm -rf, sudo, curl|bash), imported_from (только trusted). Чат-аппрув подключений. Heartbeat мониторинг. Рейтинг < 0.3 не получает задач. Автономия L0-L4.

> **Следствие:** Безопасность на уровне запуска агента, а не на уровне сети

---

## WATNODE-API: API и команды

### WATNODE-API-1: HTTP API

GET /status — состояние ноды. GET /peers — список пиров. POST /chat — отправка сообщения. GET /store/:key — чтение Redis. SSE /api/v1/stream/{session} — стриминг. MCP сервер на порту N+100.

> **Следствие:** Полный доступ к функциональности ноды через HTTP

### WATNODE-API-2: Чат-команды

/help — справка. /skills — список скиллов. /agents — список агентов. /bridges — список бриджей. /status — состояние. /mode — переключить режим. /connect <ip> — подключить пир. /chat <текст> — LLM. /say <id> <текст> — сообщение в группу. /merge — слияние агентов. /import — импорт агента.

> **Следствие:** Все команды доступны на русском и через веб-дашборд

---

## WATNODE-INSTALL: Установка и запуск

### WATNODE-INSTALL-1: Быстрый старт

Linux: wget бинарника + Redis + DeepSeek API ключ. Windows: powershell + Memurai. Docker: redis + waters-node контейнеры. VPS: ssh + бинарник. Минимальные требования: Redis 6+, DeepSeek API/Ollama, браузер Chrome 90+.

> **Следствие:** От 5 минут до запуска первой ноды
