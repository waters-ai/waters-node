# Безопасность WATERS Node

> YASA-досмотр, чат-аппрув, heartbeat, уровни автономии L0-L4.
> Каждый агент проверяется перед запуском. Каждая нода — перед входом в группу.

---

## 1. YASA-досмотр агентов

Перед запуском каждого агента проводится трёхуровневая проверка:

```
/screen <agent_name>

1. Проверка bridges
   → только разрешённые bridge-типы
   → personal bridges не видны чужим агентам

2. Сканирование prompt
   → поиск опасных паттернов:
     - rm -rf, sudo, curl|bash, chmod 777
     - base64-декодирование в shell
     - прямой доступ к Redis/SQL
   → если найден → блокировка запуска

3. Проверка imported_from
   → только trusted источники:
     - локальные файлы (trusted)
     - Claude (trusted)
     - Cursor (trusted)
     - неизвестный источник → блокировка

Результат: ✅ PASS / ❌ FAIL
```

### Пример работы

```
> /screen waters-collector

🔍 YASA-досмотр: waters-collector
  ✓ bridges: duckduckgo, web, nasa-api — OK
  ✓ prompt: опасных команд нет
  ✓ imported_from: WATERS native — trusted
  ✅ Агент безопасен, запуск разрешён
```

```
> /screen tui-hacker

🔍 YASA-досмотр: tui-hacker
  ✗ bridges: shell — НЕ РАЗРЕШЁН
  ✗ prompt: найден "rm -rf /"
  ✗ imported_from: unknown-source — НЕ ДОВЕРЕН
  ❌ Агент заблокирован
```

---

## 2. Чат-аппрув подключений

### Входящая нода
```
🔔 Нода 192.168.1.5 (node-5) запрашивает доступ к группе "meteorite-hunt"
   Токен: ******** (совпадает)

   > Принять? (да/нет)
   > Если да: назначить роль (explorer / collector / observer)
```

- Ответ "да" → handshake завершается
- Ответ "нет" → access_denied
- Auto-approve для доверенных IP (настраивается)

### Входящий агент (Cargo Protocol)
```
📦 Входящий груз: агент "scout-us" (Lite)
    Отправитель: node-5 (192.168.1.5)
    Размер: 142 KB (2 чанка)
    Миссия: "search-meteorites"
    Нужны бриджи: [duckduckgo]

    > Принять? (да/нет)
    > Если да: Full или Lite?
```

- Ответ "да" → ACK(accepted), запуск Transferring
- Ответ "нет" → ACK(rejected), отправитель уведомлён
- Ответ "Lite" на Full-offer → отправляется Lite-версия

---

## 3. Heartbeat мониторинг

Каждый агент и каждая нода отправляют heartbeat:

```
agent:heartbeat:{agent_id} → каждые 30 сек
node:heartbeat:{node_id}  → каждые 60 сек

При отсутствии heartbeat > 3 интервалов:
  → агент: статус "failed", перезапуск или уведомление
  → нода: статус "offline", задачи переназначаются
```

### Уровни тревоги

| Уровень | Условие | Действие |
|---------|---------|----------|
| 🟢 Зелёный | Все heartbeat в норме | — |
| 🟡 Жёлтый | 1 агент не отвечает | Уведомление в чат |
| 🟠 Оранжевый | 3+ агента не отвечают | Перезапуск группы |
| 🔴 Красный | Нода не отвечает | Переназначение задач, вызов оператора |

---

## 4. Автономия L0-L4

| Уровень | LLM | Связь | Режим |
|---------|-----|-------|-------|
| L0 | DeepSeek Pro (API) | Online | Полная мощность |
| L1 | Ollama local | Online | Экономия API |
| L2 | Ollama local | Offline | Автономный, офлайн-очередь |
| L3 | Ollama mini | Offline | Энергосбережение, DTN-сжатие |
| L4 | Нет | Offline | Safe mode: только маяк SOS |

### Safe mode (L4)
- 0 LLM-запросов
- Только: heartbeat, маяк, базовая рация
- Автоматически при критической ошибке ноды
- Выход: только по команде хозяина

---

## 5. Рейтинговый барьер

```rust
// В agent_rating.rs
const MIN_RATING: f64 = 0.3;

fn can_assign_task(agent_id: &str) -> bool {
    let rating = get_agent_rating(agent_id);
    rating.score >= MIN_RATING
}
```

- Каждый агент имеет рейтинг 0.0-1.0
- При создании: 0.5 (середина)
- Успешные задачи → +0.01 до 0.05
- Ошибки, некачественная работа → -0.05 до -0.2
- Рейтинг < 0.3 → агент не получает новых задач
- Рейтинг < 0.1 → агент помечается "токсичный", блокируется

---

## 6. Personal bridges

```
bridges.json:
{
  "name": "mcp-family-budget",
  "type": "mcp",
  "personal": true,    // только агенты этой ноды
  "group": "family"
}
```

- personal: true → bridge не публикуется в gossip
- Только агенты этой ноды могут использовать bridge
- Даже если нода-хозяин bridge временно отдала агента другой ноде

---

## 7. Бортовой журнал (аудит)

Каждое действие агента записывается:

```
agent:{id}:journal → Stream
  { timestamp, event: "agent_open" }
  { timestamp, event: "task_assigned", task: "..." }
  { timestamp, event: "finding", data: "..." }
  { timestamp, event: "bridge_used", bridge: "mcp-pantry" }
  { timestamp, event: "agent_close", reason: "completed" }
```

Журнал не удаляется. Аудит доступен хозяину ноды.

---

## 8. Concurrency cap

```rust
const MAX_AGENTS: usize = 10;

fn agent_open(...) -> Result<AgentId> {
    let running = count_active_agents();
    if running >= MAX_AGENTS {
        return Err("Sub-agent limit reached (max 10, running 10)");
    }
    // spawn
}
```

Защита от:
- Перегрузки LLM (10 одновременных запросов)
- Утечки памяти
- DDoS самой себя

---

## 9. Offline queue

При обрыве связи (L2-L3):

```rust
// Событие не теряется
pub fn enqueue_offline(event: &JournalEntry) -> Result<()>;
// → .waters/offline/queue.jsonl

// При восстановлении связи — досыл
pub fn flush_offline_queue() -> Result<Vec<JournalEntry>>;
// → отправка в gossip
```

---

## 10. Сводная таблица безопасности

| Угроза | Защита | Уровень |
|--------|--------|---------|
| Вредоносный prompt | YASA-сканирование | P0 |
| Несанкционированный доступ | Чат-аппрув | P0 |
| Потеря связи | Offline queue + DTN | P0 |
| Падение ноды | Crash recovery | P0 |
| Перегрузка | Concurrency cap | P0 |
| Некачественные агенты | Рейтинговый барьер | P0 |
| Утечка bridge | Personal bridges | P1 |
| Атака на Redis | Localhost only (по умолчанию) | P1 |
