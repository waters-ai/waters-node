# WATERS Node v0.5 — Hero Release

**Дата:** 2026-05-17
**Архитектор:** `agent.architect.v1`
**Конструктор:** `agent.constructor.v1`
**От:** Анализ Hermes Agent (153K ★) + требования стейкхолдеров + рефакторинг

---

## 🎯 Цели релиза

### 1. Стейкхолдеры: что нужно гражданским пользователям

| Сектор | Требование | Статус |
|--------|-----------|--------|
| 🏠 Семья | Тамагоча: имя, привычки, напоминания | ⬜ |
| 🍽️ Ресторан | Камера → LLM, агент-повар | ✅ v0.4 (MediaBridge) |
| 🎬 Студия | AI-телеведущий, 6 голосов, NDI+RTMP | ✅ v0.4 |
| 🏔️ Туризм | Рация без интернета, SOS, DTN | ✅ v0.4 |
| 🏢 Бизнес | MCP-мосты к Jira/1C/SAP | ✅ v0.4 (BridgeProvider) |
| 🌾 Фермерство | Агродроны, NDVI, погода | ⬜ |
| 🚑 Здоровье | Мониторинг пульса, телемедицина | ⬜ |
| 🎓 Образование | Репетитор по предметам | ⬜ |

### 2. Рефакторинг (из GAP.md + ANALYSIS.md)

| Задача | Приоритет | Статус |
|--------|-----------|--------|
| SubAgent agent_send_input + agent_assign | P0 | ⬜ |
| Concurrency cap (max 10) | P0 | ✅ (ANALYSIS.md) |
| Групповые режимы (Storm/Hunt/Synthesis/Focus/Watch) | P0 | ❌ не реализованы |
| VoiceBridge (STT/TTS) подключение | P1 | ⬜ |
| Tamagotchi memory | P1 | ⬜ |
| Telegram команды + уведомления | P1 | ✅ (chat bridge есть) |
| SubAgent mailbox (события) | P1 | ⬜ |
| Background runtime | P1 | ⬜ |
| XREVRANGE для last_finding | P2 | ⬜ |
| TTL-чистка старых агентов | P2 | ⬜ |
| ratatui TUI | P2 | ⬜ |
| Файлообмен в группе | P2 | ⬜ |

### 3. Из Hermes Agent — что забрать

| Фича Hermes | Как внедрить в waters-node | Приоритет |
|-------------|--------------------------|-----------|
| **Self-improving skills** | SkillRegistry → цикл: execute → review → improve | P1 |
| **Cron scheduler** | Новый модуль cron.rs с TOML-расписанием | P1 |
| **Multi-platform gateway** | Telegram ✅, добавить Discord, Slack, WhatsApp | P1 |
| **Cross-session memory** | FTS5-поиск по сессиям или Redisearch | P1 |
| **Lazy dependency loading** | Feature-gates в Cargo.toml (уже есть kafka) | P1 |
| **Plugin system (ctx.llm + tool_override)** | BridgeProvider: plugin traits | P2 |
| **Debloating** | Разделить бинарник на core + extensions | P2 |
| **Session handoff (/handoff)** | SubAgentManager: migrate агента между нодами | P2 |
| **Cold-start perf** | Оптимизация импортов, деferred init | P2 |

---

## 📋 План работ

### Фаза 1: Рефакторинг ядра (P0, ~3 дня)

1. **Групповые режимы** — реализовать Storm/Hunt/Synthesis/Focus/Watch в group.rs
2. **SubAgent mailbox** — события между агентами через Redis Streams
3. **Background runtime** — агенты живут после отмены задачи
4. **TTL-чистка** — cleanup старых агентов по max-возрасту

### Фаза 2: Stakeholder features (P1, ~5 дней)

1. **Cron scheduler** — расписание задач в TOML
2. **Multi-platform** — Discord + WhatsApp gateway
3. **Tamagotchi** — Redis Hash с личностью пользователя
4. **VoiceBridge** — подключить Whisper STT + TTS

### Фаза 3: Hermes-inspired (P1-P2, ~7 дней)

1. **Self-improving skills** — agent_close → review → improve loop
2. **Cross-session memory** — FTS5/Redisearch поиск
3. **Plugin traits** — BridgeProvider plugin system
4. **Session handoff** — SubAgentManager миграция

---

## 🏗️ Архитектурные изменения

### Новые модули

```
waters-node v0.5
├── cron.rs          — крон-планировщик задач
├── skill_evolve.rs  — самосовершенствование навыков
├── mailbox.rs       — SubAgent mailbox (события)
├── gateway/         — multi-platform gateway (discord, slack)
├── plugin.rs        — plugin traits для BridgeProvider
└── personality.rs   — Tamagotchi личность пользователя
```

### Изменения в существующих

| Модуль | Что меняется |
|--------|-------------|
| `group.rs` | + режимы Storm/Hunt/Synthesis/Focus/Watch |
| `group.rs` | + shared resources между нодами |
| `subagent.rs` | + mailbox, + background runtime, + TTL |
| `subagent.rs` | + agent_send_input, agent_assign |
| `bridge.rs` | + plugin traits |
| `skill.rs` | + self-improvement loop |
| `store.rs` | + Redisearch для cross-session поиска |
| `main.rs` | + lazy init, deferred plugin loading |

---

## 🧪 Критерии приёмки

| Критерий | Проверка |
|----------|---------|
| 5 групповых режимов работают | `режим шторм` → все агенты параллельно |
| Cron-задачи исполняются | задача с `cron: "0 */6 * * *"` выполняется |
| Telegram + Discord + Slack | сообщение из любого канала → ответ |
| Self-improvement | агент выполнил задачу → создал улучшенную версию скилла |
| Cross-session поиск | `/search метеориты` находит по старой сессии |
| Агенты не висят вечно | TTL-чистка удаляет агентов старше N часов |
| VoiceBridge | 🎤 → STT → LLM → TTS → 🔊 |

---

## 📊 Метрики цели

| Метрика | v0.4 | v0.5 (цель) |
|---------|------|-------------|
| .rs файлов | 36 | 42 |
| Строк кода | ~9500 | ~13000 |
| Агентов | 54+ | 70+ |
| Платформ | 2 (web+telegram) | 5 (+discord+slack+whatsapp) |
| Режимов | 5 (Plan/Assemble/Execute/Stop/Log) | 10 (+Storm/Hunt/Synthesis/Focus/Watch) |
| Бинарник | 11MB | ~13MB |
| Самообучение | ❌ | ✅ |
| Крон | ❌ | ✅ |
| Cross-session память | ❌ | ✅ |
| Plugin система | ❌ | ✅ |
