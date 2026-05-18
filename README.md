# WATERS Node v1.0.0

**12MB бинарник, 48+ модулей Rust, P2P-рой, 6 LLM, гибридный офлайн-режим.**

AI-агенты на любом железе: от Raspberry Pi до серверов. Работают с интернетом и без.

```bash
# Быстрый старт:
export DEEPSEEK_API_KEY=sk-xxx
export REDIS_URL=redis://127.0.0.1:6379
WATERS_HEADLESS=1 nohup ./waters-node --port 42069 &
# → http://localhost:42069
```

```
Семья ───┐
Ферма ───┤
Студия ──┤── P2P ── VPS ── 6 LLM
Офис ────┤
Туризм ──┤
Дрон ────┘
```

## Ключевые возможности v1.0.0

| Возможность | Описание |
|-------------|----------|
| 🧠 **Гибридная LLM** | Remote (DeepSeek/Ollama) + бортовая GGUF 1-3B. Работает без интернета |
| 🌐 **Распределённый инференс** | 6 нод P2P: кеш, pipeline, федерация токенов, домены |
| 🔒 **Безопасный self-improve** | 3 агента проверяют код перед внедрением (Programmer + Security + Onboard) |
| 🤖 **Self-improving** | `/self improve` — полный цикл развития |
| 📦 **MCP Store** | `/mcp search` — каталог скилов |
| 🧠 **LLM Router** | 6 провайдеров, гибридный режим, авто-переключение |
| 🔄 **A2A протокол** | Google Agent2Agent — `/a2a connect` |
| ☦️ **YASA-безопасность** | 6 заповедей (новая CMD-6 для бортовой LLM) |
| 💧 **Тамагоча** | Капелька — душа ноды |
| 🎤 **Голос** | Push-to-Talk + 6 голосов + VU-метр |
| 🎬 **Медиа** | NDI, OBS, RTMP, RTSP, ONVIF |
| 🌐 **P2P** | mDNS, TCP sync, мастер-слейв, relay, DTN |
| 🚜 **Полевые агенты** | tractor, drone, weather, soil |
| 📊 **Self-diagnose** | `/diagnose` — warnings, тесты |

## Автономия L0-L4 (гибридный режим)

| Уровень | Связь | LLM | Поведение |
|---------|-------|-----|-----------|
| L0 | Стабильная | Remote + Edge | Edge валидирует ответы |
| L1 | Лок.сеть | Ollama local | Edge как fallback |
| L2 | Прерывистая | Edge + очередь | Простые — GGUF, сложные — в SyncQueue |
| L3 | Обрывная | Только Edge | DTN-сжатый лог |
| L4 | Нет | SOS/маяк | Safe mode |

## Быстрый старт

```bash
# Linux (серверный режим)
wget https://github.com/waters-ai/waters-core/releases/download/v1.0.0/waters-node
chmod +x waters-node
export DEEPSEEK_API_KEY=sk-xxxx
export REDIS_URL=redis://127.0.0.1:6379
WATERS_HEADLESS=1 nohup ./waters-node --port 42069 &

# Linux (с бортовой LLM для офлайн)
./waters-node --port 42069 --edge-model qwen2.5-1.5b.q4_k_m.gguf
```

## Для кого это

| Кто | Как нода меняет их жизнь |
|-----|------------------------|
| 🏠 **Семья** | Домовой-агент без интернета. Рация — 0 токенов |
| 🍽️ **Ресторан** | Агент-повар + дрон. Камера над плитой → LLM |
| 🎬 **Студия** | AI-телеведущий, 6 голосов, NDI, RTMP |
| 🏔️ **Туризм** | Офлайн-карты, SOS, DTN-синхронизация |
| 🌾 **Фермерство** | NDVI полей, погода, цены. Работает без 4G |
| 🚑 **Здоровье** | Мониторинг пульса, SOS через DTN соседям |
| 🏢 **Бизнес** | MCP-мосты к Jira/1C/SAP |

## Минимальные требования

- **Redis** 6+ (docker или native)
- **DeepSeek API** ключ или **Ollama** локально
- **GGUF-модель** (опционально, для офлайн-режима)
- **Браузер** Chrome 90+ (для голоса и дашборда)

## Архитектура v1.0.0

```
BridgePool ← Gossip ← AgentMgr ← A2A
    │
HybridLlm (прослойка)
  ├── EdgeEngine (GGUF 1-3B, CPU, <500ms)
  ├── RemoteRouter (BridgePool, online)
  └── SwitchProtocol (L0-L4)
    │
DistributedInference (6 нод P2P)
  ├── DistributedCache (hash → gossip)
  ├── PipelineParallel (feature-gate)
  ├── TokenFederation (DeepSeek Flash)
  └── DomainRouter (ProfileConfig)
    │
CodeReviewPipeline (self-improve)
  ├── Programmer (код + тесты)
  ├── SecurityReviewer (YASA + OWASP)
  └── OnboardManager (RAM/CPU/compat)
```

## Документация

| Раздел | О чём |
|--------|-------|
| [ТЗ v1.0.0](docs/technical/TZ_V1.0.0.md) | Полное ТЗ для Конструктора (3 языка) |
| [Архитектура](ARCHITECTURE.md) | v1.0.0: ядро, память, сеть, агенты |
| [Гибридная LLM](LLM.md) | Remote + Edge + Distributed |
| [Установка](INSTALL.md) | Windows, Ubuntu, VPS, Docker |
| [Безопасность](docs/SECURITY.md) | YASA-6, EdgeGuard, CodeSandbox |
| [Сеть](docs/NETWORK.md) | P2P, NAT, DTN, relay |
| [Экосистема](docs/ECOSYSTEM.md) | 9 секторов, 54+ агента |

## Лицензия

MIT

---

*WATERS Node v1.0.0 — гибридная LLM, распределённый инференс, безопасный self-improve.*
*3 языка: RU (основной), EN (технический), ZH (международный)*
