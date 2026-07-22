# MiangPay

MiangPay est une application fintech panafricaine de transfert d'argent multi-pays avec Mobile Money, cartes virtuelles, fidelite, promotions, notifications et support.

Le projet est organise en monorepo :

```txt
miangpay/
|-- frontend/   # Application mobile Flutter
|-- backend/    # API Laravel 13
|-- docs/       # Documentation produit, architecture, securite, PAWAPAY
|-- deployment/ # Base infra
+-- scripts/    # Scripts projet
```

## Etat final local

- Frontend Flutter navigable avec parcours Auth, KYC, Dashboard, Transfert, Historique, Beneficiaires, Cartes, Profil, Fidelite, Promotions, Notifications, Support et etats systeme.
- Validation minimale ajoutee sur Auth, KYC et Support.
- Inscription avec acceptation obligatoire des conditions d utilisation et de la politique de confidentialite.
- Actions principales du dashboard et des ecrans clefs branchees.
- Ecran `TransferScreen` inutilise supprime.
- Backend Laravel 13 installe et executable.
- Base PostgreSQL locale `miangpay` avec donnees fictives.
- API V1 connectee a PostgreSQL pour auth demo, pays, operateurs, beneficiaires, transferts, cartes, fidelite, promotions, notifications et support.
- Frontend utilisable en mode fake par defaut ou en mode API locale via `--dart-define`.

## Prerequis locaux

- Flutter SDK.
- PHP 8.3+ avec `fileinfo`, `pdo_pgsql` et `pgsql`.
- Composer.
- PostgreSQL.

Chemins utilises sur la machine de dev actuelle :

```txt
PHP: C:\php8.4\php.exe
Composer: C:\composer\composer.bat
PostgreSQL: postgres / ludovic
```

## Base de donnees

```powershell
$env:PGPASSWORD='ludovic'
psql -U postgres -h 127.0.0.1 -p 5432 -d postgres -f backend/database/sql/00_create_database.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/01_schema.sql
psql -U postgres -h 127.0.0.1 -p 5432 -d miangpay -f backend/database/sql/02_seed_demo.sql
```

## Lancer le backend

```powershell
cd backend
$env:PATH='C:\php8.4;' + $env:PATH
C:\composer\composer.bat install
C:\php8.4\php.exe artisan key:generate --force
C:\php8.4\php.exe artisan serve --host=127.0.0.1 --port=8000
```

## Lancer le frontend

Mode demo fake, sans backend :

```powershell
cd frontend
flutter pub get
flutter run
```

Mode API locale :

```powershell
cd frontend
flutter run --dart-define=MIANGPAY_DATA_SOURCE=api --dart-define=MIANGPAY_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

Compte demo local :

```txt
Telephone: +22961000000
Mot de passe: ludovic
OTP: n'importe quel code a 6 chiffres en mode demo
```

## Verification

Backend :

```powershell
cd backend
$env:PATH='C:\php8.4;' + $env:PATH
C:\composer\composer.bat validate --strict
C:\php8.4\php.exe artisan route:list --path=api
C:\php8.4\php.exe artisan test
```

Frontend :

```powershell
cd frontend
C:\flutter\flutter\bin\cache\dart-sdk\bin\dart.exe analyze lib
```

## Prochaines etapes production

- Remplacer le token demo par une authentification reelle, par exemple Sanctum ou Passport.
- Ajouter migrations Laravel officielles si le schema SQL doit devenir source de verite applicative.
- Persister les preferences de notifications et automatiser les rafraichissements temps reel utiles.
- Ajouter une vraie recherche/filtre sur les beneficiaires et historiques quand les volumes augmentent.
- Integrer PAWAPAY via l'adaptateur prevu, avec environnement sandbox puis production.
- Ajouter tests API par endpoint et tests widget sur les parcours critiques.
