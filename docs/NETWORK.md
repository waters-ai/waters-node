# Сеть WATERS Node v1.0.0 / Network / 网络

## 1. [RU] Топология

```
Прямое P2P (оба с публичным IP)
Master-Slave (один за NAT)
Hub-and-Spoke (все через VPS)
Полная mesh (6 нод)
```

## 2. [RU] Порты

| Сервис | Порт | Относительно HTTP |
|--------|------|-------------------|
| HTTP (веб-дашборд) | N | — |
| MCP Server | N+100 | N + 100 |
| TCP sync | N+3 | N + 3 |
| mDNS | N+1 | N + 1 |

## 3. [RU] Новые gossip-сообщения (v1.0.0)

```
DistGossipMessage:
  CacheRequest  { key }       — поиск в распределённом кеше
  CacheResponse { key, value } — ответ на запрос
  TensorChunk   { tensor }     — тензор для pipeline parallelism
  TokenAlloc    { node, tokens } — распределение токенов
```

## 4. [RU] DTN (Delay/Disruption Tolerant Networking)

| Параметр | Значение |
|----------|---------|
| Размер пакета | 256 байт |
| Макс очередь | 1000 событий |
| TTL события | 24 часа |
| Сжатие | gzip level 6 |
| Retry | каждые 5 мин, макс 3 |

## 5. [RU] LLM-пакет для DTN (новое в v1.0.0)

```
DtnLlmPacket:
  magic: b"WLLM"
  seq: u32
  node_id: UUID
  payload: gzip(GGUF response)
  checksum: crc32
```

---

*Обновлено для v1.0.0. Добавлены: DistGossipMessage, DtnLlmPacket.*
