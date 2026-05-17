# WATERS Node v0.5.0-alpha — установка Windows
Write-Host "🌊 WATERS Node v0.5.0-alpha — установка" -ForegroundColor Cyan

$installDir = "$env:LOCALAPPDATA\waters-node"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

$url = "https://github.com/waters-ai/waters-core/releases/download/v0.5.0-alpha/waters-node.exe"
$out = "$installDir\waters-node.exe"

Write-Host "📥 Скачиваю..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $url -OutFile $out

Write-Host "✅ Установлено в $out" -ForegroundColor Green
Write-Host ""
Write-Host "Запуск:" -ForegroundColor Cyan
Write-Host '  $env:DEEPSEEK_API_KEY="sk-xxxx"'
Write-Host '  $env:REDIS_URL="redis://127.0.0.1:6379"'
Write-Host "  $out --port 42070"
