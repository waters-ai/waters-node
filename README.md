# 🌊 WATERS Node v0.4

**Агентский интернет. P2P-рой агентов с Redis, голосом и медиа.**

Один бинарник (11MB) = целая нода. 3 ноды = сеть. Каждая нода = свой LLM.

```
Дача (Win) ────┐
                ├── P2P ── 177 (сервер, DeepSeek)
Дом (Ubuntu) ──┘          
                       Все ноды видят чат, агентов, голос
```

## Возможности

| Фича | Как |
|------|-----|
| 🤖 25+ агентов | TUI-code + WATERS профессии (повар, монтажёр, лаборант) |
| 🎤 Голос (0 токенов) | Рация: зажал 🎤 → говоришь → все ноды слышат |
| 🧠 Голос агенту | 🤖 → микрофон → DeepSeek → ответ голосом |
| 🔊 6 голосов | Разные голоса для разных агентов |
| 🌐 P2P | Ноды соединяются и синхронизируются |
| 📦 Redis persistence | Все данные в Redis, не теряются |
| 🎬 Медиа-мосты | NDI, OBS, RTMP, HDMI для студий |
| 🔒 YASA-досмотр | Каждый агент проверяется на безопасность |
| 📊 Рейтинг агентов | ★ голосование, топ, ранг |
| 🔄 Слияние | merge двух агентов в третьего |
| 📥 Импорт | TUI/Claude/Cursor → наш формат |

## Быстрый старт

```bash
# Linux
wget https://github.com/waters-ai/waters-node/releases/download/v0.4/waters-node
chmod +x waters-node
export DEEPSEEK_API_KEY=sk-xxxx
export REDIS_URL=redis://127.0.0.1:6379
./waters-node --port 42069
# → http://localhost:42069

# Windows
# Скачать waters-node.exe, открыть PowerShell:
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
                  ┌─────────────────────────────────┐
                  │         НОДА (waters-node)       │
                  │                                  │
                  │  LLM Bridge (DeepSeek/Ollama)    │
                  │  SubAgent Manager (Redis)        │
                  │  P2P Gossip (mDNS + TCP)         │
                  │  Group Chat (Redis Streams)      │
                  │  Media Mixer (NDI/OBS/RTMP)      │
                  │  MCP Server (агенты как tools)   │
                  │  Voice Bridge (WebRTC/SSE)       │
                  │  Web Dashboard (SSE streaming)   │
                  └──────────┬──────────────────────┘
                             │
                    P2P sync │
                             ▼
                   ┌──────────────────┐
                   │    ДРУГИЕ НОДЫ   │
                   │  (до 6 в группе) │
                   └──────────────────┘
```

## Документация

- [Установка](INSTALL.md) — Windows, Ubuntu, 177
- [Архитектура](ARCHITECTURE.md) — как устроена нода
- [Подключение нод](CONNECT.md) — P2P, группа, чат
- [LLM управление](LLM.md) — провайдеры, ключи, модели
- [Агенты](AGENTS.md) — создание, управление, слияние
- [Голос](VOICE.md) — рация, агент-голос, 6 профилей
- [Команды](COMMANDS.md) — полный список /команд
- [Дистрибутивы](dist/README.md) — готовые сборки

## Лицензия

MIT
