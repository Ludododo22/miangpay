# MiangPay Backend

Backend API Laravel pour MiangPay.

## Objectif

Ce dossier prépare l'architecture backend de MiangPay : authentification, KYC, pays, corridors, transferts, bénéficiaires, cartes virtuelles, fidélité, promotions, notifications, support et administration.

## Principe PAWAPAY

PAWAPAY n'est pas intégré directement dans les contrôleurs. Le backend utilise une interface :

```php
PaymentGatewayInterface
```

Implémentations prévues :

- `FakePaymentGateway` pour le développement et les tests.
- `PawapayPaymentGateway` pour la production.

## Installation Laravel recommandée

Si Laravel n'est pas encore installé :

```bash
composer create-project laravel/laravel backend-temp
cp -R backend/* backend-temp/
# puis renommer backend-temp en backend selon ton environnement
```

Ou intégrer les fichiers de ce dossier dans une installation Laravel 10/11 existante.

## Modules API prévus

- Auth & OTP
- KYC
- Pays & opérateurs
- Corridors & frais
- Bénéficiaires
- Transferts
- Historique & reçus
- Cartes virtuelles
- Fidélité
- Promotions
- Notifications
- Support
- Admin
