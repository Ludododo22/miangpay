param(
    [string]$PhpPath = "C:\php8.4\php.exe",
    [string]$HostName = "127.0.0.1",
    [string]$Port = "8000"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$BackendDir = Join-Path $Root "backend"

Write-Host "Starting MiangPay API on http://$HostName`:$Port" -ForegroundColor Cyan
Set-Location $BackendDir
& $PhpPath artisan serve --host=$HostName --port=$Port
