# Управление LLM

## Провайдеры

Нода поддерживает **6 LLM-провайдеров** (по одному на каждую из 6 нод в группе):

| Провайдер | Настройка | Модель по умолчанию |
|-----------|-----------|-------------------|
| **DeepSeek** | `DEEPSEEK_API_KEY` | `deepseek-chat` |
| **Ollama** | `OLLAMA_HOST` | `qwen2.5:14b` |
| **OpenAI** | `OPENAI_API_KEY` | `gpt-4o` |
| **Claude** | через bridges.json | `claude-sonnet-4` |
| **OpenRouter** | через bridges.json | любой |
| **Custom** | bridges.json | любой |

## Настройка

### Через переменные окружения

```bash
# Основной провайдер (определяет нода)
export DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxx

# Ollama (локальный fallback)
export OLLAMA_HOST=http://127.0.0.1:11434
```

### Через bridges.json

```json
{
  "llm": {
    "providers": [],
    "custom": {
      "name": "deepseek",
      "provider": "deepseek",
      "model": "deepseek-chat",
      "url": "https://api.deepseek.com",
      "api_key": "{DEEPSEEK_API_KEY}",
      "enabled": true
    },
    "active": "deepseek"
  }
}
```

## Переключение между LLM

В консоли ноды:

```
/llm                       # список доступных LLM
/llm set deepseek          # переключить на DeepSeek
/llm set ollama            # переключить на Ollama
/llm set openai            # переключить на OpenAI
```

## 6 нод = 6 LLM (P2P роутинг)

```
Нода 1 (DeepSeek Pro)  ───┐
Нода 2 (Ollama 7B)     ───┤
Нода 3 (Claude Sonnet) ───┤── P2P группа
Нода 4 (GPT-4o)        ───┤
Нода 5 (DeepSeek Flash)───┤
Нода 6 (Custom)        ───┘

agent_open с указанием LLM:
  agent_open("анализ", skill="spectra", llm="claude")
    → система находит ноду с Claude
    → spawn агента на той ноде
    → результат → Finding → Redis → вся группа видит
```

## Кэширование

Redis DB 15 хранит кэш ответов LLM (TTL 60 сек). Повторный запрос с тем же input
не тратит токены.

```bash
# Размер кэша:
redis-cli -n 15 DBSIZE
```

## Офлайн-режим (L0-L4)

| Уровень | LLM | Kafka | Режим |
|---------|-----|-------|-------|
| L0 | DeepSeek (API) | Online | Полная мощность |
| L1 | Ollama (local) | Online | Экономия API |
| L2 | Ollama (local) | Offline | Автономный |
| L3 | Ollama mini | Offline | Энергосбережение |
| L4 | Нет | Offline | Safe mode |
