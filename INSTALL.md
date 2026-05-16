# Установка WATERS Node v0.4

## 🐧 Ubuntu / Linux

```bash
# 1. Redis
sudo apt update && sudo apt install -y redis-server
sudo systemctl start redis

# 2. Скачать бинарник
wget https://github.com/waters-ai/waters-node/releases/download/v0.4/waters-node
chmod +x waters-node

# 3. Скачать конфиги и агентов (опционально)
wget https://github.com/waters-ai/waters-node/releases/download/v0.4/agents.tar.gz
tar xzf agents.tar.gz

# 4. Запуск
export DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxx
export REDIS_URL=redis://127.0.0.1:6379
./waters-node --port 42069
```

## 🪟 Windows

```powershell
# 1. Redis (один из вариантов)
# Вариант A: WSL
wsl --install -d Ubuntu
wsl sudo apt update && sudo apt install -y redis-server
wsl sudo redis-server --daemonize yes

# Вариант B: Memurai (рекомендуется)
# https://www.memurai.com/ — скачать и установить

# 2. Скачать бинарник
# https://github.com/waters-ai/waters-node/releases/download/v0.4/waters-node.exe

# 3. Запуск в PowerShell
$env:DEEPSEEK_API_KEY = "sk-xxxxxxxxxxxxxxxx"
$env:REDIS_URL = "redis://127.0.0.1:6379"
.\waters-node.exe --port 42070
```

## ☁️ Сервер 177 (Ubuntu)

```bash
ssh constructor@87.242.102.177
cd ~/waters-node
export DEEPSEEK_API_KEY=sk-xxxxxxxxxxxx
./start.sh
# или руками:
./waters-node --port 42069
```

## 🐳 Docker (альтернатива)

```bash
# Redis в Docker
docker run -d --name waters-redis -p 6379:6379 redis:7-alpine

# Нода
docker run -d --name waters-node \
  -e DEEPSEEK_API_KEY=sk-xxxx \
  -e REDIS_URL=redis://host.docker.internal:6379 \
  -p 42069:42069 \
  waters-node:latest
```

## 🔄 Обновление

```bash
# Просто заменить бинарник и перезапустить
./waters-node --port 42069
# Все данные в Redis сохраняются
```

## 📋 Проверка установки

```bash
# После запуска открыть в браузере:
http://localhost:42069

# В консоли ноды проверить:
status
# Должно быть: Redis ✅, Skills 25+
```
