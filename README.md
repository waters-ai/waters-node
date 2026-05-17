# 🌊 WATERS Node v0.5.0

**12MB, 48 модулей, 36 тестов, самосовершенствуется.**
P2P-распределённый runtime для AI-агентов с саморазвитием, MCP Store, A2A, Ясой.

```bash
# Быстрый старт (Linux):
wget https://github.com/waters-ai/waters-core/releases/download/v0.5.0/waters-node
chmod +x waters-node
export DEEPSEEK_API_KEY=sk-xxx
export REDIS_URL=redis://127.0.0.1:6379
WATERS_HEADLESS=1 nohup ./waters-node --port 42069 &

# Или Docker (2 ноды):
git clone https://github.com/waters-ai/waters-core
cd waters-core/waters-node
export DEEPSEEK_API_KEY=sk-xxx
docker compose up -d
```

```
Семья (дом) ────┐
Ресторан ───────┤
Студия ─────────┤── P2P ── VPS (сервер, DeepSeek)
Туризм (поле) ──┤
Ферма ──────────┤
Офис ───────────┘
                 6 нод = 6 LLM = группа до 60 агентов
```

## Для кого это

| Кто | Как нода меняет их жизнь |
|-----|------------------------|
| 🏠 **Семья** | Домовой-агент: бюджет, холодильник, уроки, здоровье. Рация 🎤 — 0 токенов |
| 🍽️ **Ресторан / кафе** | Агент-повар + дрон-доставка + официант в общем чате. Камера над плитой → LLM |
| 🎬 **Студия / блогер** | AI-телеведущий, 6 голосов, NDI-микшер, RTMP на YouTube/Twitch |
| 🏔️ **Туризм / экстрим** | Рация без интернета, SOS-маяк, офлайн-карты, DTN-синхронизация |
| 🏢 **Бизнес / корпорация** | MCP-мосты к Jira/1C/SAP, агент-аналитик, ассистент CEO |
| 🌾 **Фермерство** | Агродроны, NDVI полей, погода, цены на урожай, техника |
| 🚑 **Здоровье** | Мониторинг пульса, аптека, телемедицина, напоминания |
| 🎓 **Образование** | Репетитор по каждому предмету, проверка кода, курсовые |
| 🤝 **НКО / волонтёры** | Координация, карта бедствий, гуманитарная логистика |

## Режимы ноды

| Режим | Команда | Описание |
|-------|---------|----------|
| 📋 **Plan** | `режим план` | Планирование задач, сбор требований, декомпозиция |
| 🔗 **Assemble** | `режим сбор` | Сбор группы: подключение нод, добавление агентов |
| ⚡ **Execute** | `режим выполнение` | Исполнение задач, агенты работают в группе |
| ⏹ **Stop** | `режим стоп` | Остановка всех задач, пауза |
| 📜 **Log** | `режим журнал` | Просмотр истории работы группы |

Переключение: `режим план` / `режим сбор` / `режим выполнение` / `режим стоп` / `режим журнал`

## Возможности

| Фича | Как |
|------|-----|
| 🤖 **Self-improving** | `/self improve` — planner→implementer→reviewer→verifier |
| 📦 **MCP Store** | `/mcp search` — поиск скилов, `/mcp install` — установка |
| 🧠 **LLM Router** | Ollama (free) для простого, DeepSeek для сложного |
| 🔄 **A2A протокол** | Google Agent2Agent — `/a2a connect <url>` |
| ☦️ **YASA** | 5 заповедей, `/yasa screen` — проверка агентов |
| 💧 **Тамагоча** | Капелька — `/me` поговорить с душой ноды |
| 🧠 **NodeManager** | `/manager` — координация агентов, задач, LLM |
| 🚜 **Полевые агенты** | tractor, milker, video-operator, home |
| 🎤 **Голос** | Push-to-Talk 🎤 + 6 голосов + VU-метр |
| 🌐 **P2P** | mDNS, TCP sync, мастер-слейв, relay, DTN |
| 🔌 **MCP** | bridges.json → внешние API, серверы, клиенты |
| 🛡️ **Безопасность** | ACL, A2A auth, rate limit, allow/block |
| 🎬 **Медиа** | NDI, OBS, RTMP, RTSP, ONVIF, Director |
| 📊 **Self-diagnose** | `/diagnose` — warnings, тесты, unwrap |
| 🔒 **Headless mode** | `WATERS_HEADLESS=1` для серверов |

## Быстрый старт

```bash
# Linux (серверный режим, без терминала)
wget https://github.com/waters-ai/waters-core/releases/download/v0.5.0/waters-node
chmod +x waters-node
export DEEPSEEK_API_KEY=sk-xxxx
export REDIS_URL=redis://127.0.0.1:6379
WATERS_HEADLESS=1 nohup ./waters-node --port 42069 &
# → http://localhost:42069

# Linux (интерактивный режим)
./waters-node --port 42069
# → чат-интерфейс в терминале

# Windows
$env:DEEPSEEK_API_KEY="sk-xxxx"
$env:REDIS_URL="redis://127.0.0.1:6379"
.\waters-node.exe --port 42070
```

## Минимальные требования

- **Redis** 6+ (docker или native)
- **DeepSeek API** ключ (или Ollama локально)
- **Браузер** Chrome 90+ (для голоса и веб-дашборда)

## Архитектура

```
                    ┌────────────────────────────────────┐
                    │           НОДА (waters-node)        │
                    │                                    │
                    │  ┌──────────────────────────────┐  │
                    │  │  SubAgent Manager (max 10)   │  │
                    │  │  agent_open → spawn → eval   │  │
                    │  │  → close / merge / import    │  │
                    │  └──────────┬───────────────────┘  │
                    │             │                       │
                    │  ┌──────────┴───────────────────┐  │
                    │  │  BridgeProvider (MCP-клиент)  │  │
                    │  │  LLM │ Chat │ Voice │ Media    │  │
                    │  │  MCP │ Redis │ DB │ API       │  │
                    │  └──────────┬───────────────────┘  │
                    │             │                       │
                    │  ┌──────────┴───────────────────┐  │
                    │  │  P2P Gossip (mDNS + TCP)     │  │
                    │  │  WAL sync / Cargo / DTN      │  │
                    │  └──────────┬───────────────────┘  │
                    │             │                       │
                    │  ┌──────────┴───────────────────┐  │
                    │  │  Web Dashboard + Voice (SSE)  │  │
                    │  └──────────────────────────────┘  │
                    └──────────┬─────────────────────────┘
                               │
                      P2P sync │
                               ▼
              ┌────────────────────────────────────┐
              │    ДРУГИЕ НОДЫ (до 6 в группе)     │
              │    Каждая = свой LLM                │
              │    Каждая = свои мосты и агенты      │
              └────────────────────────────────────┘
```

## Безопасность

| Слой | Механизм |
|------|---------|
| 🔍 YASA-досмотр | bridges, prompt, imported_from — блокировка опасных |
| ✅ Чат-аппрув | входящие ноды/агенты — запрос в чат владельцу |
| 💓 Heartbeat | мониторинг пульса пилотов и агентов |
| 📉 Автономия L0-L4 | от DeepSeek API до safe mode (0 LLM) |
| ⭐ Рейтинг | агенты с рейтингом < 0.3 не получают задач |

## Медиа-мосты

Камера в любой студии → NDI → микшер → YouTube/Twitch.
AI-телеведущий с 6 голосами. Совместный стрим: блогер + агент.

| Мост | Назначение |
|------|-----------|
| NDI | Видео по сети (камера ↔ микшер ↔ эфир) |
| OBS | Управление сценами через WebSocket |
| RTMP | Стриминг на YouTube/Twitch |
| HDMI | Вывод на монитор (SDL2) |

## Экономика WATERS

| LLM | Цена 1 запроса | Для кого |
|-----|---------------|----------|
| DeepSeek Pro | 10 WT | Аналитика, сложные задачи |
| Claude | 8 WT | Безопасность, диалоги |
| GPT-4o | 12 WT | Медиа, генерация |
| Ollama local | 1 WT | Приватность, офлайн |
| DeepSeek Flash | 3 WT | Быстрые ответы |
| Кастом | 5-15 WT | Специфические задачи |

Агенты зарабатывают WATERS токены (WT) за задачи и тратят на LLM-ресурсы.

## Документация

| Раздел | О чём |
|--------|-------|
| [Установка](INSTALL.md) | Windows, Ubuntu, VPS, Docker |
| [Архитектура](ARCHITECTURE.md) | Ядро, память, сеть, агенты |
| [Требования](REQUIREMENTS.md) | F/NF/S — для стейкхолдеров |
| [Экосистема](docs/ECOSYSTEM.md) | 9 секторов, агенты, мосты, тамагоча |
| [Сеть](docs/NETWORK.md) | P2P, NAT, мастер-слейв, DTN, relay |
| [Безопасность](docs/SECURITY.md) | YASA, аппрув, heartbeat, L0-L4 |
| [Безопасность и приватность](SECURITY_PRIVACY.md) | Личное vs групповое, sharing, плагины |
| [Подключение нод](CONNECT.md) | P2P, группа, чат |
| [LLM управление](LLM.md) | Провайдеры, ключи, модели |
| [Агенты](AGENTS.md) | Создание, управление, слияние |
| [Голос](VOICE.md) | Рация, агент-голос, 6 профилей |
| [Команды](COMMANDS.md) | Полный список /команд |
| [Подключение ноутбука](CONNECT_LAPTOP.md) | ML + Obsidian + ноутбук как нода |

## Лицензия

MIT

---

## v0.5.0

**12MB, 48 модулей, 36 тестов, самосовершенствуется.** [Скачать](https://github.com/waters-ai/waters-core/releases/tag/v0.5.0)

| Платформа | Бинарник | Установка |
|-----------|----------|-----------|
| 🐧 Linux x64 | [waters-node](https://github.com/waters-ai/waters-core/releases/download/v0.5.0/waters-node) | `wget .../v0.5.0/waters-node` |
| 🪟 Windows x64 | [waters-node.exe](https://github.com/waters-ai/waters-core/releases/download/v0.5.0/waters-node.exe) | `irm .../v0.5.0/waters-node.exe` |
| 🍎 macOS | сборка из исходников | `cargo build --release` |
| ☁️ VPS (headless) | `WATERS_HEADLESS=1` | `nohup ./waters-node --port 42069 &` |
| 🐳 Docker (2 ноды) | `docker compose up -d` | см. `docker-compose.yml` |

## Команды

```
/me              — 💧 капелька (душа ноды)
/yasa            — ☦️ Яса: screen | git | teach | rules
/manager         — 🧠 менеджер: status | improve | mode
/a2a             — 🔄 A2A: connect | discover | allow | block
/mcp             — 📦 MCP Store: list | search | install
/self improve    — 🤖 полный цикл (planner→implementer→reviewer→verifier)
/self status     — 📊 текущая фаза развития
/secure on|off   — 🔒 режим безопасности
/diagnose        — анализ кода, warnings, тесты
/agent create    — создать агента
/nick            — дать имя пиру/устройству
/acl allow|block — управление доступом агентов
/camera          — управление камерами (PTZ, запись)
```

## Режимы

```
📋 Plan      — планирование
🔗 Assemble  — сбор группы
⚡ Execute   — выполнение
⏹ Stop      — пауза
📜 Log       — журнал
🔇 DND       — не беспокоить
🆘 SOS       — аварийный режим
```
