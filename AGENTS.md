# Агенты WATERS / Agents / 智能体

## [RU] Типы агентов

### TUI-совместимые (7 ролей)
tui-general, tui-explorer, tui-planner, tui-reviewer, tui-implementer, tui-verifier, tui-custom

### WATERS профессии (10+ ролей)
waters-collector, waters-scout, waters-analyst, waters-synthesizer, waters-coordinator, waters-archivist, waters-camera-operator, waters-video-editor, waters-lab-operator, waters-specialist

### Импортированные
tui-*, claude-*, cursor-*, merged-*

## [RU] Команды

```
/agent create <skill> [bg]    — создать агента
/agent list                   — список активных
/assign <id> <task>           — назначить задачу
/send <id> <message>          — отправить сообщение
/merge <name1> <name2>        — слить двух агентов
/screen <agent>               — YASA-досмотр
/rating <agent>               — рейтинг
```

## [RU] YASA CMD-6 (новое в v1.0.0)
При использовании бортовой LLM (EdgeEngine) агенты автоматически проверяются на точность ответов через `ValidateEdgeResponse`.

## [RU] Жизненный цикл

```
agent_open → Pending → Running → Completed / Failed / Cancelled
                                    ↓
                            Findings → Redis Stream
                                    ↓
                            Rating update → score + rank
```

## [RU] Concurrency cap
Максимум **10 активных агентов** одновременно.

---

*Обновлено для v1.0.0. Три языка: RU, EN, ZH.*
