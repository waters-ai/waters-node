#!/bin/bash
set -euo pipefail

echo "🌊 WATERS Node v0.5.0-alpha — установка"
echo ""

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
    Linux)  BINARY="waters-node";;
    Darwin) BINARY="waters-node-macos";;
    *)      echo "❌ Неизвестная ОС: $OS"; exit 1;;
esac

INSTALL_DIR="${INSTALL_DIR:-$HOME/waters-node}"
mkdir -p "$INSTALL_DIR"

if [ "$OS" = "Linux" ] && [ "$ARCH" = "x86_64" ]; then
    URL="https://github.com/waters-ai/waters-core/releases/download/v0.5.0-alpha/waters-node"
elif [ "$OS" = "Darwin" ]; then
    echo "⚠️ macOS: требуется сборка из исходников."
    echo "   git clone https://github.com/waters-ai/waters-core"
    echo "   cd waters-core/waters-node && cargo build --release"
    exit 0
else
    echo "❌ $ARCH не поддерживается. Соберите из исходников."
    exit 1
fi

echo "📥 Скачиваю $BINARY..."
curl -sL "$URL" -o "$INSTALL_DIR/waters-node"
chmod +x "$INSTALL_DIR/waters-node"

echo "✅ Установлено в $INSTALL_DIR/waters-node"
echo ""
echo "Запуск:"
echo "  export DEEPSEEK_API_KEY=sk-xxxx"
echo "  export REDIS_URL=redis://127.0.0.1:6379"
echo "  $INSTALL_DIR/waters-node --port 42069"
