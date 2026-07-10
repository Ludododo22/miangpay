# MiangPay Frontend

Application mobile Flutter de MiangPay.

## Stack

- Flutter
- Riverpod
- GoRouter
- Dio
- Flutter Secure Storage / Hive
- Material 3

## Fonctionnalites couvertes

- Splash et onboarding
- Authentification locale et appels API optionnels
- Verification OTP demo
- Parcours KYC
- Dashboard principal
- Transfert d'argent avec calcul de frais et recu
- Beneficiaires
- Historique
- Cartes virtuelles
- Profil et securite
- Fidelite
- Promotions
- Notifications et messages
- Support
- Etats systeme

## Sources de donnees

Le frontend utilise les fake repositories par defaut pour rester demonstrable sans backend.

Pour utiliser l'API Laravel locale :

```powershell
flutter run --dart-define=MIANGPAY_DATA_SOURCE=api --dart-define=MIANGPAY_API_BASE_URL=http://127.0.0.1:8000/api/v1
```

Endpoints deja branches cote frontend :

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/verify-otp`
- `GET /user/profile`
- `GET /countries`
- `GET /beneficiaries`
- `POST /transfer/calculate`
- `POST /transfer/send`
- `GET /transfer/history`
- `GET /cards`
- `GET /cards/{id}`
- `POST /cards`
- `POST /cards/{id}/load`
- `POST /cards/{id}/block`
- `POST /cards/{id}/unblock`
- `GET /notifications`
- `GET /promotions/active`
- `GET /support/tickets`

## Lancement

```powershell
flutter pub get
flutter run
```

## Verification

```powershell
C:\flutter\flutter\bin\cache\dart-sdk\bin\dart.exe analyze lib
```

## Notes

Le mode API est volontairement progressif : les fake repositories restent disponibles pendant le branchement complet des donnees secondaires, des actions d'ecriture et du module fidelite en `AsyncValue`.
