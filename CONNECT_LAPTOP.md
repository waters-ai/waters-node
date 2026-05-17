# Подключение ноутбука к WATERS Node

> Как превратить ноутбук (Mac/Win/Linux) в полноценную ноду с ML-инструментами и Obsidian.

---

## 1. Зачем подключать ноутбук

| Сценарий | Что даёт |
|----------|----------|
| **ML-разработка** | Jupyter/VS Code на ноутбуке → агенты ноды используют ваши модели |
| **Obsidian как память** | Заметки в Obsidian → автоматическая индексация в памяти ноды |
| **Локальные LLM** | Ollama на ноутбуке → дешёвый LLM для агентов |
| **Медиа-продакшн** | NDI с камеры ноутбука → студия на VPS |
| **Полевая работа** | Ноутбук как DTN-буфер при обрывах связи |

---

## 2. Быстрое подключение

### Linux / macOS

```bash
# 1. Установить Redis (если нет)
# macOS:
brew install redis && brew services start redis
# Ubuntu:
sudo apt install redis-server && sudo systemctl start redis

# 2. Скачать waters-node
wget https://github.com/waters-ai/waters-node/releases/download/v0.4/waters-node
chmod +x waters-node

# 3. Подключиться к VPS-ноде
./waters-node --port 42070 --connect 171.22.180.177:42069
#                        ↑ локальный порт     ↑ адрес master-ноды
```

### Windows (PowerShell)

```powershell
# 1. Установить Memurai (Windows-native Redis)
# https://www.memurai.com/

# 2. Скачать waters-node
Invoke-WebRequest -Uri "https://github.com/waters-ai/waters-node/releases/download/v0.4/waters-node" -OutFile "waters-node.exe"

# 3. Подключиться
$env:REDIS_URL="redis://127.0.0.1:6379"
.\waters-node.exe --port 42070 --connect 171.22.180.177:42069
```

---

## 3. ML-инструменты (на ноутбуке)

### 3.1 Ollama — локальные LLM

```toml
# config/bridges.json
{
  "llm": {
    "providers": [
      {
        "name": "ollama",
        "provider": "ollama",
        "url": "http://127.0.0.1:11434",
        "model": "qwen2.5:7b",
        "enabled": true
      }
    ]
  }
}
```

Теперь агенты могут использовать ваш локальный Ollama:

```
/chat напиши стих про ноутбук
# Агент использует Ollama + Redis, 0 токенов
```

### 3.2 Jupyter Notebook как MCP-мост

```bash
# Установить jupyter-mcp
pip install jupyter-mcp

# Запустить MCP-сервер Jupyter
jupyter-mcp --port 5000
```

Добавить в `config/bridges.json`:
```json
{
  "mcp_servers": [
    {
      "name": "jupyter",
      "command": "jupyter-mcp",
      "args": ["--port", "5000"],
      "tools": ["run_cell", "list_kernels", "get_output"],
      "enabled": true
    }
  ]
}
```

Теперь агент может выполнять ML-код:
```
/chat обучи модель на данных из CSV
# → агент вызывает run_cell в Jupyter на ноутбуке
```

### 3.3 MLflow / Weights & Biases

```json
{
  "bridges": [
    {
      "name": "wandb",
      "provider": "mcp",
      "transport": "http",
      "config": {
        "url": "https://api.wandb.ai",
        "api_key": "{env:WANDB_API_KEY}"
      },
      "enabled": true
    }
  ]
}
```

---

## 4. Obsidian как внешняя память

### 4.1 Подключение Obsidian через Local REST API

1. Установить плагин **Local REST API** в Obsidian
2. Настроить порт (по умолчанию 27123)
3. Добавить bridge в `config/bridges.json`:

```json
{
  "bridges": [
    {
      "name": "obsidian",
      "provider": "mcp",
      "transport": "http",
      "config": {
        "url": "http://127.0.0.1:27123",
        "api_key": "{env:OBSIDIAN_API_KEY}"
      },
      "enabled": true
    }
  ]
}
```

### 4.2 Obsidian → Redis sync

```bash
# Скрипт синхронизации заметок в Redis
# Запускать через cron каждые 5 минут или при изменении

python3 << 'PYEOF'
import requests, json, os

OBSIDIAN_PORT = 27123
REDIS_URL = os.environ.get("REDIS_URL", "redis://127.0.0.1:6379")

# 1. Получить все заметки из Obsidian
resp = requests.get(f"http://127.0.0.1:{OBSIDIAN_PORT}/vault/")
notes = resp.json()

# 2. Сохранить в Redis Stream для поиска
import redis
r = redis.Redis.from_url(REDIS_URL)
for note in notes[:100]:
    r.xadd("memory:obsidian", {
        "path": note["path"],
        "content": note["content"][:5000],
        "modified": note["mtime"]
    })
print(f"Synced {len(notes)} notes to Redis")
PYEOF
```

### 4.3 Поиск по Obsidian через чат

```
/chat найди в Obsidian заметки про ML
# → агент ищет по Redis Stream memory:obsidian
# → находит релевантные заметки
# → отвечает с цитатами
```

---

## 5. Топология: ноутбук + VPS

```
┌─────────────────┐     P2P sync     ┌──────────────────────┐
│  НОУТБУК (вы)   │ ◄──────────────► │  VPS (сервер 177)    │
│  port 42070      │                  │  port 42069           │
│                  │                  │                       │
│  ● Ollama        │                  │  ● DeepSeek (осн.)    │
│  ● Jupyter       │                  │  ● Telegram Bot      │
│  ● Obsidian      │                  │  ● WhatsApp Bridge   │
│  ● VS Code       │                  │  ● WeChat Bridge     │
│  ● Локальные     │                  │  ● Постоянный Redis  │
│    файлы         │                  │  ● NDI/OBS студия    │
└─────────────────┘                  └──────────────────────┘
```

### Что это даёт

| Ресурс ноутбука | Использование | Экономия |
|----------------|---------------|----------|
| Ollama (7B) | Быстрые ответы, 0 токенов | $0/мес |
| Jupyter GPU | ML-вычисления | Не нужен GPU-сервер |
| Obsidian | Долговременная память | Не нужна отдельная БД |
| VS Code | Редактирование агентов | Локальный UX |
| Камера | NDI-видео для студии | Не нужна камера VPS |

---

## 6. Проверка связи

```bash
# На ноутбуке после подключения:
status
# → Peers: 1
# → Connected to waters-177

# В групповом чате:
/say 1 привет с ноутбука!
# → Все ноды группы видят сообщение
```

---

## 7. Безопасность

- Все соединения — TCP (не UDP), через авторизацию по токену группы
- Ноутбук за NAT → подключается как slave к VPS
- VPS не имеет доступа к локальным файлам ноутбука (только через MCP-мосты)
- Sensitive данные (API ключи) — только в переменных окружения
