param(
    [string]$ApiBaseUrl = "http://127.0.0.1:8000/api/v1"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$FrontendDir = Join-Path $Root "frontend"

Write-Host "Starting Flutter with Laravel API: $ApiBaseUrl" -ForegroundColor Cyan
Set-Location $FrontendDir
flutter run --dart-define=MIANGPAY_DATA_SOURCE=api --dart-define=MIANGPAY_API_BASE_URL=$ApiBaseUrl
