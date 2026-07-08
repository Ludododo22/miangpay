# MiangPay

MiangPay est une plateforme fintech panafricaine de transfert d'argent multi-pays avec Mobile Money, cartes virtuelles, fidélité, promotions, notifications et support.

## Structure

```txt
miangpay/
├── frontend/   # Application mobile Flutter
├── backend/    # API Laravel / architecture backend
├── docs/       # Documentation produit, UX, API, sécurité, déploiement
├── deployment/ # Docker, Nginx, scripts infra
└── scripts/    # Scripts projet
```

## État actuel

- `frontend/` contient le Front Office Flutter complet avec données fictives.
- `backend/` contient le squelette Laravel-ready, l'architecture prévue, les endpoints, les migrations documentées et les interfaces de gateway.
- PAWAPAY sera intégré plus tard via un adaptateur dédié.

## Commandes Git

```bash
git init
git add .
git commit -m "feat: initialize MiangPay monorepo"
git branch -M main
git remote add origin https://github.com/Ludododo22/miangpay.git
git push -u origin main
```

## Développement frontend

```bash
cd frontend
flutter pub get
flutter run
```

## Développement backend

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

> Le dossier backend est préparé pour Laravel. Il faudra lancer `composer create-project laravel/laravel backend` ou intégrer ces fichiers dans une installation Laravel complète si nécessaire.
