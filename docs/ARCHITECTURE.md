# Architecture MiangPay

## Frontend

Flutter avec architecture modulaire :

- `core/` : thème, router, design system
- `features/` : modules fonctionnels
- Riverpod pour l'état
- GoRouter pour la navigation
- Fake repositories pour la démonstration avant API réelle

## Backend

Laravel API avec PostgreSQL, Redis et Sanctum.

Le backend devra exposer des API REST versionnées sous `/api/v1`.

## Paiement

MiangPay utilise une interface `PaymentGatewayInterface` pour isoler la logique PAWAPAY.

Développement : `FakePaymentGateway`
Production : `PawapayPaymentGateway`
