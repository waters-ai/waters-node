# Установка WATERS Node v1.0.0

## 🐧 Ubuntu / Linux

```bash
# 1. Redis
sudo apt update && sudo apt install -y redis-server
sudo systemctl start redis

# 2. Скачать бинарник
wget https://github.com/waters-ai/waters-core/releases/download/v1.0.0/waters-node
chmod +x waters-node

# 3. (Опционально) Скачать GGUF-модель для офлайн-режима
wget https://huggingface.co/Qwen/Qwen2.5-1.5B-GGUF/resolve/main/qwen2.5-1.5b-q4_k_m.gguf

# 4. Запуск
export DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxx
export REDIS_URL=redis://127.0.0.1:6379
./waters-node --port 42069 --edge-model qwen2.5-1.5b-q4_k_m.gguf
```

## 🪟 Windows

```powershell
# 1. Memurai (Windows-native Redis): https://www.memurai.com/

# 2. Скачать бинарник
# https://github.com/waters-ai/waters-core/releases/download/v1.0.0/waters-node.exe

# 3. Запуск
$env:DEEPSEEK_API_KEY = "sk-xxxxxxxxxxxxxxxx"
$env:REDIS_URL = "redis://127.0.0.1:6379"
.\waters-node.exe --port 42070 --edge-model qwen2.5-1.5b-q4_k_m.gguf
```

## ☁️ VPS (Headless)

```bash
ssh user@your-vps-ip
export DEEPSEEK_API_KEY=sk-xxxx
export REDIS_URL=redis://127.0.0.1:6379
WATERS_HEADLESS=1 nohup ./waters-node --port 42069 --edge-model ./model.gguf &
```

## 🐳 Docker

```bash
docker run -d --name waters-redis -p 6379:6379 redis:7-alpine
docker run -d --name waters-node \
  -e DEEPSEEK_API_KEY=sk-xxxx \
  -e REDIS_URL=redis://host.docker.internal:6379 \
  -p 42069:42069 \
  waters-node:latest
```

## 📋 Проверка установки

```bash
http://localhost:42069
# → статус ноды, LLM, пиры
```

---

*Обновлено для v1.0.0. Бортовая модель — опционально.*
