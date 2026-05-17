#!/bin/bash
# WATERS Node — развёртывание в поле (ферма, село)
# Работает на Raspberry Pi / Orange Pi / слабом ПК

set -euo pipefail

echo "🌾 WATERS Node — Полевое развёртывание"
echo ""

# 1. Установка зависимостей
echo "📦 Установка зависимостей..."
if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y redis-server mosquitto mosquitto-clients python3-pip
elif command -v yum &>/dev/null; then
    sudo yum install -y redis mosquitto python3-pip
fi

# 2. Настройка Redis для поля (минимум памяти)
sudo tee /etc/redis/redis.conf << 'REDIS'
bind 127.0.0.1
port 6379
daemonize yes
maxmemory 128mb
maxmemory-policy allkeys-lru
REDIS
sudo systemctl restart redis

# 3. Скачать waters-node
echo "📥 Скачивание..."
mkdir -p ~/waters-node
cd ~/waters-node
wget -q https://github.com/waters-ai/waters-core/releases/download/v0.5.0-alpha/waters-node -O waters-node
chmod +x waters-node

# 4. Конфиг для поля
cat > .env << 'ENV'
DEEPSEEK_API_KEY=
REDIS_URL=redis://127.0.0.1:6379
WATERS_MODE=field
WATERS_DASHBOARD_PASSWORD=field
ENV

# 5. Запуск
echo "✅ Полевая нода готова."
echo "   Запуск: ./waters-node --port 42069"
echo "   Веб: http://localhost:42069 (пароль: field)"
