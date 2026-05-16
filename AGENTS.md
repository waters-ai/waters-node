# Агенты WATERS

## Типы агентов

### TUI-совместимые (7 ролей 1:1)

| Агент | Роль | Что делает |
|-------|------|-----------|
| `tui-general` | general | Всё |
| `tui-explorer` | explore | Поиск (только чтение) |
| `tui-planner` | plan | Проектирование |
| `tui-reviewer` | review | Ревью |
| `tui-implementer` | implement | Реализация |
| `tui-verifier` | verify | Тестирование |
| `tui-custom` | custom | Кастом |

### WATERS профессии (10+ ролей)

| Агент | Роль | Что делает |
|-------|------|-----------|
| `waters-collector` | collector | Сбор данных (NASA API, web) |
| `waters-scout` | scout | Разведка (поиск по источникам) |
| `waters-analyst` | analyst | Анализ (классификация, паттерны) |
| `waters-synthesizer` | synthesizer | Синтез (отчёты, статьи) |
| `waters-coordinator` | coordinator | Оркестрация (назначение задач) |
| `waters-archivist` | archivist | Память (ChromaDB, LightRAG) |
| `waters-camera-operator` | camera-operator | Камеры, фото, видео, NDI |
| `waters-video-editor` | video-editor | Монтаж, цветокоррекция |
| `waters-lab-operator` | lab-operator | Спектрометры, микроскопы |
| `waters-specialist` | specialist | Кастом под SKILL.md |

### Импортированные

| Префикс | Откуда |
|---------|--------|
| `tui-*` | Из TUI SKILL.md |
| `claude-*` | Из Claude CLAUDE.md |
| `cursor-*` | Из Cursor .cursorrules |
| `merged-*` | Результат слияния агентов |

## Команды управления

```
/agent create <skill>              — создать агента
/agent create <skill> bg           — фоновый агент (не умирает)
/agent list                        — список активных агентов
/assign <agent_id> <task>          — назначить задачу
/send <agent_id> <message>         — отправить сообщение агенту
/merge <name1> <name2>            — слить двух агентов
/screen <agent>                    — досмотр безопасности
/rating <agent>                    — рейтинг агента
/rate <agent> <score> [review]     — оценить агента
/top                               — топ агентов по рейтингу
```

## Импорт агентов из других систем

```bash
# Из TUI SKILL.md
/import ~/.deepseek/skills/my-agent/SKILL.md

# Из Claude
/import ~/project/CLAUDE.md

# Из Cursor
/import ~/project/.cursorrules

# Массовый импорт из папки
/import-dir ~/.deepseek/skills/
```

## Экспорт

```bash
/export waters-collector tui      → SKILL.md (TUI-совместимый)
/export waters-collector claude   → CLAUDE.md (Claude-совместимый)
/export waters-collector cursor   → .cursorrules (Cursor-совместимый)
/export waters-collector waters   → наш формат
```

## Слияние агентов

```bash
/merge waters-collector waters-analyst
  → merged-waters-collector-waters-analyst
  → наследует bridges + tools + findings обоих
  → создаётся skill.json + SKILL.md
```

## Жизненный цикл

```
agent_open → Pending → Running → Completed / Failed / Cancelled
                                    │
                            Findings → Redis Stream
                                    │
                            Rating update → score + rank
```

## Concurrency cap

Максимум **10 активных агентов** одновременно (защита от перегрузки).
При попытке создать 11-го:

```
Ошибка: Sub-agent limit reached (max 10, running 10)
```
