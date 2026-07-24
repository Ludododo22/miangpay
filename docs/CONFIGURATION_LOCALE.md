# Configuration locale MiangPay

Cette page regroupe les commandes de configuration utiles pour travailler en local sur le projet.

## Prerequis

- PHP 8.3+ avec `fileinfo`, `pdo_pgsql` et `pgsql`.
- Composer.
- PostgreSQL local.
- Flutter SDK.

Chemins utilises sur la machine actuelle :

```txt
PHP: C:\php8.4\php.exe
Composer: C:\composer\composer.bat
PostgreSQL: postgres / ludovic
```

## Base de donnees

Depuis la racine du projet :

```powershell
.\scripts\setup_database.ps1
```

Ce script execute :

```powershell
psql -U postgres -h 127.0.0.1 -p 5432 -d postgres -f backend/database/sql/00_create_database.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/01_schema.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/02_seed_demo.sql
```

## Backend API

Depuis la racine du projet :

```powershell
.\scripts\start_backend.ps1
```

L'API sera disponible sur :

```txt
http://127.0.0.1:8000/api/v1
```

## Frontend Flutter en mode API

Depuis la racine du projet :

```powershell
.\scripts\run_frontend_api.ps1
```

Ce script lance Flutter avec :

```powershell
--dart-define=MIANGPAY_DATA_SOURCE=api
--dart-define=MIANGPAY_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

## Verification complete

Depuis la racine du projet :

```powershell
.\scripts\verify_project.ps1
```

Ce script lance :

- `composer validate --strict`
- `php artisan test`
- `dart analyze lib`

## Compte demo

```txt
Telephone: +22961000000
Mot de passe: ludovic
OTP: n'importe quel code a 6 chiffres en mode demo
```
