#!/bin/bash
# WATERS — подключение к мастер-ноде VPS
# Запуск: ./connect-vps.sh <VPS_IP> [порт]

VPS_IP="${1:?Ошибка: укажи IP VPS сервера
Пример: ./connect-vps.sh 1.2.3.4 42069}"
PORT=${2:-42069}
REDIS_URL="${REDIS_URL:-redis://127.0.0.1:6379}"
DEEPSEEK_API_KEY="${DEEPSEEK_API_KEY:?Ошибка: установи DEEPSEEK_API_KEY}"

echo "═══ WATERS v0.4 — подключение к $VPS_IP:$PORT ═══"
echo ""

exec ./waters-node \
  --port $PORT \
  --connect "$VPS_IP:$PORT"
