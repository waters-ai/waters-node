# Экосистема WATERS Node v1.0.0 / Ecosystem / 生态系统

> 9 секторов жизни, 6 нод = 6 LLM, гибридный офлайн-режим, 54+ агента.

## [RU] 9 секторов использования

| Сектор | Нода | Бортовая GGUF | Ключевые агенты |
|--------|------|---------------|-----------------|
| 🏠 Дом | Ollama + Flash | qwen2.5-3b | house-manager, elderly-monitor |
| 🎓 Образование | DeepSeek + Claude | qwen2.5-1.5b | personal-tutor, coding-judge |
| 🍽️ Бизнес | Flash + GPT-4o | tinylama-1.1b | shop-keeper, delivery-coordinator |
| 🏢 Корпорация | DeepSeek Pro | qwen2.5-3b | executive-assistant, data-analyst |
| 🎬 Медиа | GPT-4o + Claude | — | tv-host, video-editor |
| 🏔️ Туризм | Ollama Local | tinylama-1.1b | hike-buddy, safety-beacon |
| 🌾 Фермерство | DeepSeek Flash | qwen2.5-3b | crop-monitor, weather-analyst |
| 🚑 Здоровье | Claude | qwen2.5-3b | health-monitor, emergency-alerter |
| 🤝 НКО | любой | qwen2.5-1.5b | disaster-coordinator |

## [RU] 6 нод = 6 LLM = гибридный роутинг

```
agent_open("анализ", llm="claude")
  → система находит ноду с Claude
  → если нода офлайн → EdgeEngine (GGUF бортовой)
  → если сложный запрос → SyncQueue → при reconnect → remote LLM
```

## [RU] Гибридный режим (новое в v1.0.0)

Каждая нода может работать в трёх режимах:
1. **Online** (L0-L1): Remote LLM + EdgeEngine валидирует
2. **Offline light** (L2): EdgeEngine на простые + очередь
3. **Offline deep** (L3-L4): Только EdgeEngine + SOS

---

*Обновлено для v1.0.0. Три языка: RU (основной), EN (технический), ZH (международный)*
