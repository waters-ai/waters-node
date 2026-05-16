# Экосистема WATERS

> 9 секторов жизни, 6 нод = 6 LLM, 54+ агента, MCP-мосты к внешним системам.
> Тамагоча хозяина — личность ноды.

---

## 9 секторов использования

```
                      ┌──────────────────────────┐
                      │  НОДА 1 (DeepSeek Pro)   │
                      │  Группы: Корпорация       │
                      │          Образование       │
                      └──────────────────────────┘
                      ┌──────────────────────────┐
                      │  НОДА 2 (Claude Sonnet)  │
                      │  Группы: Безопасность      │
                      │          Медицина          │
                      └──────────────────────────┘
┌─────────────────┐  ┌──────────────────────────┐  ┌─────────────────┐
│ НОДА 3 (GPT-4o) │  │  НОДА 4 (Ollama Local)   │  │ НОДА 5 (Flash)  │
│ Медиа, Креатив  │  │  Дом, Туризм, Село        │  │ Быстрые задачи  │
└─────────────────┘  └──────────────────────────┘  └─────────────────┘
                      ┌──────────────────────────┐
                      │  НОДА 6 (OpenRouter)     │
                      │  Кастом, резерв           │
                      └──────────────────────────┘
```

---

## 1. 🏠 Дом и семья

**Нода:** Ollama Local (приватность) + DeepSeek Flash (быстро)

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `house-manager` | smart-home, zigbee, mqtt | Свет, тепло, замки, розетки |
| `family-chef` | pantry, grocery, recipes | Меню, закупки, холодильник |
| `finance-keeper` | bank-api, bills | Бюджет, коммуналка, налоги |
| `children-tutor` | wikipedia, arxiv, school-api | Уроки, репетиторство |
| `elderly-monitor` | health-watch, pharmacy | Лекарства, пульс, напоминания |
| `pet-carer` | vet-api, pet-store | Корм, ветклиники, прогулки |

### Тамагоча хозяина
```redis
agent:family:members        → ["папа", "мама", "Даша", "Петя"]
agent:family:preferences    → { "папа": "яичница", "мама": "овсянка" }
agent:family:schedule       → "Петя в школу к 8:00"
agent:tamagotchi:days-known → 47
agent:tamagotchi:mood       → "satisfied"
```
Нода знает имена, привычки, расписание. Если долго нет задач — "грустит" в чате.

### Сквозной сценарий
```
07:00 — house-manager: будильник, свет, чайник
07:30 — children-tutor: проверка домашки Петя
08:00 — finance-keeper: "сегодня коммуналка 5000₽"
12:00 — family-chef: "в холодильнике нет молока, заказать?"
19:00 — рация 🎤: папа говорит — все ноды слышат
```

---

## 2. 🎓 Образование

**Нода:** DeepSeek Pro (анализ) + Claude (диалог)

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `personal-tutor` | wikipedia, arxiv, khan-academy | Репетитор по предметам |
| `essay-reviewer` | dictionary, deepL | Проверка сочинений |
| `flashcard-maker` | — | Карточки для запоминания |
| `study-planner` | calendar | Расписание подготовки |
| `language-partner` | dictionary, speech | Собеседник на языке |
| `coding-judge` | leetcode, github | Проверка кода |

---

## 3. 🍽️ Малый бизнес (рестораны, кафе, магазины)

**Нода:** DeepSeek Flash (быстро) + GPT-4o (камеры)

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `shop-keeper` | pos, inventory, crm | Касса, склад, клиенты |
| `customer-support` | telegram, chat | Ответы клиентам |
| `delivery-coordinator` | drone-api, maps | Дроны, курьеры, маршруты |
| `staff-scheduler` | calendar | График сотрудников |
| `marketer` | social-api, ads | Соцсети, реклама, акции |
| `supplier-connector` | supplier-api | Закупки у поставщиков |
| `food-inspector` | ndi-kitchen-cam | Камера над плитой → LLM |

### Сквозной сценарий
```
Рыбак (Токио) ловит тунца → агент-логист (Дубай) назначает дрона
→ дрон везёт в ресторан → повар готовит → официант подаёт
→ камера на кухне → NDI → YouTube → AI-телеведущий комментирует
→ казначей списывает 5 WT со счёта гостя
```

---

## 4. 🏢 Корпорация

**Нода:** DeepSeek Pro

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `executive-assistant` | email, calendar, slack | Помощник CEO |
| `data-analyst` | postgres, bi, excel | Аналитика, отчёты, KPI |
| `hr-assistant` | hr-api, linkedin | Поиск, онбординг |
| `legal-drafter` | docflow, garant | Договоры, шаблоны |
| `meeting-minutes` | calendar, slack | Протоколы совещаний |
| `project-tracker` | jira, confluence | Статусы, дедлайны |

---

## 5. 🎬 Медиа / стриминг / студия

**Нода:** GPT-4o (генерация) + Claude (сценарии)

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `tv-host` | ndi, obs, rtmp | AI-телеведущий в эфире |
| `video-editor` | ffmpeg, obs | Монтаж, цвет, звук |
| `music-composer` | suno, stable-audio | Музыка под настроение |
| `voice-actor` | elevenlabs, tts | 6 голосовых профилей |
| `stream-manager` | obs, rtmp, chat | Сцены, реклама, модерация |
| `social-replier` | social-api, telegram | Ответы на комментарии в эфире |
| `camera-operator` | ndi, hdmi | Управление камерами |

### Сквозной сценарий
```
Блогер + AI-телеведущий ведут прямой эфир из двух студий:
- Нода 3 (Москва): GPT-4o генерирует аватар ведущего
- Нода 3 (Лондон): Claude пишет сценарий
- Обе ноды → NDI → OBS → RTMP → YouTube
- Зрители пишут в чат → social-replier отвечает голосом ведущего
```

---

## 6. 🏔️ Туризм / экстрим

**Нода:** Ollama Local (офлайн) + Рация (0 токенов)

### Уровни автономии
| L | Связь | Что работает |
|---|-------|-------------|
| L0 | 4G | Полная мощность, все LLM |
| L1 | WiFi (лагерь) | Ollama local, офлайн-карты |
| L2 | Прерывистая | 🎤 Рация, магазин, трек |
| L3 | Обрывная | DTN-сжатие, SOS |
| L4 | Нет | Safe mode: только маяк |

### Агенты
| Агент | Мосты | L |
|-------|-------|---|
| `hike-buddy` | maps, weather, offline-wiki | L0-L2 |
| `safety-beacon` | sos, bluetooth-beacon | L3-L4 |
| `photo-journalist` | camera, storage | L0-L2 |
| `wildlife-spotter` | flora-fauna-db | L0-L2 |
| `group-coordinator` | mesh-bt, dtn | L1-L4 |
| `starfinder` | spice, ephemeris | L2-L4 |

---

## 7. 🌾 Село / фермерство

**Нода:** DeepSeek Flash (дёшево)

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `crop-monitor` | ndvi, drone, sentinel | Поля, всходы, болезни |
| `weather-analyst` | weather-farm | Прогноз, заморозки |
| `irrigation-planner` | soil-sensors, pump | Полив по расписанию |
| `market-pricer` | market-prices | Когда продавать урожай |
| `equipment-tracker` | gps, parts | Трактора, комбайны, ремонт |
| `veterinary` | vet-db, pharmacy | Здоровье животных |

---

## 8. 🚑 Здоровье

**Нода:** Claude (безопасность)

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `health-monitor` | fitbit, health-watch | Пульс, давление, сон, SpO2 |
| `medication-reminder` | pharmacy | Расписание лекарств |
| `emergency-alerter` | sos, sms, call | Вызов помощи при падении |
| `fitness-coach` | fitbit, video | Тренировка, техника |
| `nutritionist` | recipes, health-db | Диета, калории, аллергены |
| `telemed-connector` | video-call, fhir | Связь с врачом |

---

## 9. 🤝 НКО / волонтёрство

**Нода:** любой LLM

### Агенты
| Агент | Мосты | Что делает |
|-------|-------|-----------|
| `disaster-coordinator` | usgs, emergency-map | Карта бедствий, оповещения |
| `volunteer-matcher` | maps, chat | Назначение волонтёров |
| `fundraiser` | payment-api, social | Сборы, донаты |
| `logistics-manager` | supply-chain | Гуманитарная логистика |
| `situation-reporter` | social, telegram | Сводки для штаба |

---

## Тамагочи-слой (личность ноды)

Каждая нода хранит личность своего хозяина:

```
agent:tamagotchi:
  personality: "заботливый" | "деловой" | "творческий"
  mood: "happy" | "bored" | "needs-attention"
  days-known: 47
  owner-name: "Павел"
  owner-voice-print: <hash>
  easter-eggs: [
    "фраза: 'С добрым утром' → ответ: 'И тебе не хворать'"
  ]
```

- Если ноду долго не кормили задачами → пишет в чат: *"Хозяин, я скучаю"*
- Узнаёт голос хозяина → своё приветствие
- Поздравляет с днём рождения, праздниками
- Easter eggs: фразы, которые нода узнаёт и реагирует

---

## 6 нод = 6 LLM = роутинг

```
agent_open("анализ спектра", llm="claude")
  → система находит ноду с Claude (владелец: Лондон)
  → spawn агента на той ноде
  → результат → Finding → Redis Stream → вся группа видит
  → если Лондон офлайн → fallback на LLM ноды-владельца задачи
```

### Ценовые уровни LLM
| LLM | Нода | WT/запрос | Для задач |
|-----|------|-----------|-----------|
| DeepSeek Pro | Н1 | 10 | Аналитика, планирование |
| Claude | Н2 | 8 | Безопасность, этика |
| GPT-4o | Н3 | 12 | Медиа, генерация |
| Ollama local | Н4 | 1 | Приватность, офлайн |
| DeepSeek Flash | Н5 | 3 | Быстрые ответы |
| OpenRouter | Н6 | 5-15 | Кастом |
