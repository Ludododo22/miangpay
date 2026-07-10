# MiangPay Backend

Backend API Laravel 13 pour MiangPay.

## Objectif

Ce dossier prepare l'architecture backend de MiangPay : authentification, KYC, pays, corridors, transferts, beneficiaires, cartes virtuelles, fidelite, promotions, notifications, support et administration.

Le runtime Laravel est en place et les controleurs API V1 sont branches sur la base PostgreSQL locale de demonstration via le query builder Laravel.

## Base PostgreSQL locale

Configuration utilisee en local :

```txt
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=miangpay
DB_USERNAME=postgres
DB_PASSWORD=ludovic
```

Les scripts sont disponibles dans `backend/database/sql/`.

```powershell
$env:PGPASSWORD='ludovic'
psql -U postgres -h 127.0.0.1 -p 5432 -d postgres -f backend/database/sql/00_create_database.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/01_schema.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/02_seed_demo.sql
```

## Demarrage local

Prerequis :

- PHP 8.3+ avec `fileinfo`, `pdo_pgsql` et `pgsql` actifs.
- Composer.
- PostgreSQL local.

Installation et verification :

```powershell
cd backend
$env:PATH='C:\php8.4;' + $env:PATH
C:\composer\composer.bat install
C:\php8.4\php.exe artisan key:generate --force
C:\php8.4\php.exe artisan route:list --path=api
C:\php8.4\php.exe artisan test
```

Lancement API :

```powershell
cd backend
C:\php8.4\php.exe artisan serve --host=127.0.0.1 --port=8000
```

Lancement Flutter en mode API locale :

```powershell
cd frontend
flutter run --dart-define=MIANGPAY_DATA_SOURCE=api --dart-define=MIANGPAY_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

## Endpoints demo disponibles

Endpoints publics :

- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/verify-otp`
- `GET /api/v1/countries`
- `GET /api/v1/countries/{code}`
- `GET /api/v1/operators/{countryCode}`
- `GET /api/v1/corridors`

Endpoints de demonstration avec fallback utilisateur local :

- `GET /api/v1/user/profile`
- `POST /api/v1/user/kyc`
- `GET|POST|PUT|DELETE /api/v1/beneficiaries`
- `POST /api/v1/beneficiaries/{id}/favorite`
- `POST /api/v1/transfer/calculate`
- `POST /api/v1/transfer/send`
- `GET /api/v1/transfer/status/{idOrReference}`
- `GET /api/v1/transfer/history`
- `GET|POST|PUT|DELETE /api/v1/cards`
- `POST /api/v1/cards/{id}/load`
- `POST /api/v1/cards/{id}/block`
- `POST /api/v1/cards/{id}/unblock`
- `GET /api/v1/loyalty/overview`
- `GET /api/v1/promotions/active`
- `GET /api/v1/notifications`
- `GET|POST|PUT|DELETE /api/v1/support/tickets`

Pendant cette phase demo, les endpoints normalement proteges utilisent l'utilisateur fictif `+22961000000` si aucune authentification reelle n'est encore activee.

## Principe PAWAPAY

PAWAPAY n'est pas integre directement dans les controleurs. Le backend utilise une interface :

```php
PaymentGatewayInterface
```

Implementations prevues :

- `FakePaymentGateway` pour le developpement et les tests.
- `PawapayPaymentGateway` pour la production.

## Authentification reelle

Les routes API fonctionnent aujourd'hui en mode demo. L'integration d'une authentification reelle, par exemple via Sanctum ou Passport, reste l'etape suivante avant une exposition publique.
