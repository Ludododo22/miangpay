Set-Item Env:PGPASSWORD ludovic

Write-Host 'Preparing MiangPay PostgreSQL database...' -ForegroundColor Cyan

psql -U postgres -h 127.0.0.1 -p 5432 -d postgres -f backend\database\sql\00_create_database.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend\database\sql\01_schema.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend\database\sql\02_seed_demo.sql

Write-Host 'Database ready: miangpay' -ForegroundColor Green
