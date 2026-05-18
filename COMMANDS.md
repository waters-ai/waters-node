# Команды WATERS Node v1.0.0

## Управление агентами
`/agent create <skill> [bg]` | `/agent list` | `/assign <id> <task>` | `/send <id> <message>`
`/screen <name>` | `/merge <n1> <n2>` | `/rating <name>` | `/rate <name> <score>` | `/top`

## LLM (новое в v1.0.0)
`/llm` — список провайдеров | `/llm set <name>` — переключить
`/llm mode auto|local|remote` — режим hybrid_llm
`/llm edge status` — статус бортовой GGUF

## Чат
`/say [group] <text>` | `/chat [group] <text>` | `/opinions [group] [task]`

## Сеть
`/connect <ip>:<port>` | `status` | `/find`

## Задачи
`/task create <title> <desc>` | `/task assign <id> <agent>` | `/task list` | `/task done <id>`

## Группы
`/group create <name>` | `/group list` | `/group invite <name> <node>` | `/group mode <name> <mode>`

## MCP
`/mcp list` | `/mcp search <query>` | `/mcp install <name>` | `/mcp uninstall <name>`
`/mcp tap add <url>` | `/mcp tap remove <url>`

## Self-improve (новое в v1.0.0)
`/self improve` — полный цикл с ревью | `/self status` — текущая фаза
`/self review <pr_id>` — ручной запуск ревью

## Безопасность
`/yasa screen <agent>` | `/yasa rules` | `/secure on|off`
`/privacy show` | `/privacy share <type> <name>`

## Голос
`/toggle voice` | `/voice profile <n>` | `/voice test`

## Медиа
`/camera` | `/camera ptz left`

## Разное
`/skills` | `/bridges` | `/diagnose` | `/help` | `/exit` | `/lang set ru|en|zh`
