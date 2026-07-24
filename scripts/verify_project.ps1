param(
    [string]$PhpPath = "C:\php8.4\php.exe",
    [string]$ComposerPath = "C:\composer\composer.bat",
    [string]$DartPath = "C:\flutter\flutter\bin\cache\dart-sdk\bin\dart.exe"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$BackendDir = Join-Path $Root "backend"
$FrontendDir = Join-Path $Root "frontend"

Write-Host "Validating backend dependencies..." -ForegroundColor Cyan
Set-Location $BackendDir
& $ComposerPath validate --strict

Write-Host "Running Laravel tests..." -ForegroundColor Cyan
& $PhpPath artisan test

Write-Host "Analyzing Flutter frontend..." -ForegroundColor Cyan
Set-Location $FrontendDir
& $DartPath analyze lib

Write-Host "MiangPay verification completed." -ForegroundColor Green
