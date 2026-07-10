# Base de donnees locale MiangPay

Ces scripts initialisent une base PostgreSQL de demonstration pour MiangPay.

## Configuration locale

```txt
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=miangpay
DB_USERNAME=postgres
DB_PASSWORD=ludovic
```

## Execution manuelle

```powershell
$env:PGPASSWORD='ludovic'
psql -U postgres -h 127.0.0.1 -p 5432 -d postgres -f backend/database/sql/00_create_database.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/01_schema.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/02_seed_demo.sql
```

Les scripts sont idempotents : ils creent les tables si besoin et inserent les donnees fictives via `ON CONFLICT`, sans reinitialiser toute la base.
