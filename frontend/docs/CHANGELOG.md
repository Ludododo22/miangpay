# MiangPay — Changelog

## v3_frontoffice_auth_kyc

- Ajout du module Authentification étendu : Register, OTP, Forgot Password.
- Ajout du module KYC complet : Intro, Personal Info, Address, Document Upload mock, Selfie mock, Review, Pending.
- Ajout de composants Flutter réutilisables : OtpInput, ProgressStepper, AppEmptyState.
- Mise à jour du routeur GoRouter.
- Mise à jour du README.

## v2_frontoffice

- Navigation principale à 5 onglets.
- Modules Front Office : Dashboard, Transfer, Beneficiaries, History, Cards, Loyalty, Promotions, Profile, Notifications, Support.

## v1_scaffold

- Initialisation Flutter.
- Thème MiangPay.
- Design System initial.
- Splash, Onboarding, Country Selection, Login, Dashboard.

## v4 - Module Transfert démo
- Ajout des modèles `CountryModel`, `OperatorModel`, `BeneficiaryModel`, `FeeQuoteModel`, `ReceiptModel`.
- Ajout du datasource fake et repository du module Transfert.
- Ajout des providers Riverpod du brouillon de transfert.
- Ajout du parcours complet : type, pays, bénéficiaire, nouveau bénéficiaire, montant, résumé, PIN, traitement, succès et reçu.
- Ajout des widgets `AmountInputCard`, `FeeSummaryCard`, `TransferTimeline`, `ReceiptCard`.
