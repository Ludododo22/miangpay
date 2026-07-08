# Intégration PAWAPAY

PAWAPAY sera intégré après validation du compte marchand.

## Stratégie

1. Garder le frontend fonctionnel avec fake data.
2. Développer le backend avec `FakePaymentGateway`.
3. Tester toute la logique métier sans dépendance externe.
4. Ajouter `PawapayPaymentGateway` lorsque les clés API seront disponibles.
5. Activer le gateway réel via `.env` :

```env
PAYMENT_GATEWAY=pawapay
```
