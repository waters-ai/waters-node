# Управление LLM / LLM Management / LLM 管理

## [RU] Провайдеры

Нода поддерживает **6 LLM-провайдеров** (по одному на каждую из 6 нод в группе):

| Провайдер | Настройка | Модель по умолчанию |
|-----------|-----------|-------------------|
| **DeepSeek** | `DEEPSEEK_API_KEY` | `deepseek-chat` |
| **Ollama** | `OLLAMA_HOST` | `qwen2.5:14b` |
| **OpenAI** | `OPENAI_API_KEY` | `gpt-4o` |
| **Claude** | через bridges.json | `claude-sonnet-4` |
| **OpenRouter** | через bridges.json | любой |
| **Custom** | bridges.json | любой |

## [RU] Гибридная LLM (hybrid_llm) — новое в v1.0.0

Прозрачная прослойка между LLM Router и агентами. Автоматически переключает источник:

```
Запрос агента → HybridLlm.query(prompt, Auto)
  ├── L0: Remote (DeepSeek/Ollama) + Edge валидирует
  ├── L1: Remote + Edge как fallback
  ├── L2: Edge (GGUF 1-3B) на простые, сложные в очередь
  ├── L3: Только Edge + DTN-сжатый лог
  └── L4: Safe mode (SOS/маяк)
```

### [RU] Бортовая LLM (EdgeEngine)
- GGUF-модель 1-3B через llama-cpp-rs или candle
- CPU-инференс, <500ms на RPi4
- Не требует интернета

### [RU] Упреждающая загрузка
PrefetchCache предзагружает вероятные ответы на основе активных задач в Redis DB 14-15.

## [RU] Распределённый инференс (distributed_inference) — новое в v1.0.0

Четыре подрежима, автовыбор по условиям:

| Режим | Условие | Описание |
|-------|---------|----------|
| DistributedCache | hash(prompt) → 6 нод | Поиск <200ms, 80% hit |
| PipelineParallel | feature-gate | Модель по слоям, тензоры P2P |
| TokenFederation | DeepSeek Flash API | Единый пул, полная автономия |
| DomainRouter | ProfileConfig | Роутинг по доменам |

## [EN] Three-layer structure

```
Agent → HybridLlm → EdgeEngine (GGUF 1-3B, offline)
                  → RemoteRouter (BridgePool, online)
                  → DistributedInference (P2P, 6 nodes)
```

## [ZH] 三层结构

```
智能体 → HybridLlm → EdgeEngine（GGUF 1-3B，离线）
                  → RemoteRouter（BridgePool，在线）
                  → DistributedInference（P2P，6个节点）
```

---

## [RU] Настройка

### Через переменные окружения

```bash
export DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxx
export OLLAMA_HOST=http://127.0.0.1:11434
```

### Через bridges.json

```json
{
  "llm": {
    "custom": {
      "name": "deepseek",
      "provider": "deepseek",
      "model": "deepseek-chat",
      "url": "https://api.deepseek.com",
      "api_key": "{DEEPSEEK_API_KEY}",
      "enabled": true
    }
  }
}
```

### [RU] Бортовая модель (новое в v1.0.0)

```toml
[edge]
model = "qwen2.5-1.5b.q4_k_m.gguf"
cache_ttl = 300
max_tokens = 512
```

## [RU] Кэширование

| Кэш | Redis DB | TTL | Назначение |
|-----|----------|-----|-----------|
| LLM cache | DB 15 | 60s | Повторные запросы |
| Edge cache | DB 14 | 300s | Бортовая LLM |
| Distributed | DB 1-6 | config | P2P-кеш 6 нод |

## [RU] Переключение между LLM

```
/llm                       # список доступных LLM
/llm set deepseek          # переключить провайдера
/llm mode auto|local|remote # режим hybrid_llm
```

## [RU] 6 нод = 6 LLM (P2P роутинг)

```
Нода 1 (DeepSeek Pro)  ───┐
Нода 2 (Ollama 7B)     ───┤
Нода 3 (Claude Sonnet) ───┤── P2P группа
Нода 4 (GPT-4o)        ───┤
Нода 5 (DeepSeek Flash)───┤
Нода 6 (Custom)        ───┘
```

## [RU] Офлайн-режим (L0-L4) — v1.0.0

| Уровень | LLM | Бортовая GGUF | Режим |
|---------|-----|---------------|-------|
| L0 | DeepSeek API | Валидация | Полная мощность |
| L1 | Ollama local | Fallback | Экономия API |
| L2 | — | Простые запросы | Автономный |
| L3 | — | Только бортовая | Энергосбережение |
| L4 | — | SOS | Safe mode |

---

*Обновлено для v1.0.0. Три языка: RU (основной), EN (технический), ZH (международный)*
