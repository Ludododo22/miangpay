# MiangPay

MiangPay est une application mobile fintech panafricaine de transfert d'argent multi-pays via Mobile Money, avec intégration PAWAPAY, cartes virtuelles, fidélité, promotions et back-office administrateur.

## Stack Frontend

- Flutter 3.22+
- Riverpod
- GoRouter
- Dio
- Hive / Flutter Secure Storage
- Material 3

## Modules prévus

- Splash & Onboarding
- Authentification
- KYC
- Dashboard
- Transfert d'argent
- Bénéficiaires
- Historique & reçus
- Cartes virtuelles
- Fidélité
- Promotions
- Notifications
- Profil & sécurité
- Support
- Back-office admin

## Lancer le projet

```bash
flutter pub get
flutter run
```

## État actuel

Ce dépôt contient le squelette Flutter initial, le design system de base, les routes principales et les premiers écrans : Splash, Onboarding, Choix du pays, Login et Dashboard placeholder.

## Lot ajouté — Front office principal

Le projet contient maintenant les premiers écrans utilisables de la V1 :

```txt
Splash → Onboarding → Choix pays → Login → Dashboard principal
```

Depuis le Dashboard, la navigation principale donne accès à :

- Transfert
- Cartes virtuelles
- Activités / historique
- Profil

Des routes additionnelles existent aussi pour :

- Bénéficiaires
- Fidélité
- Promotions
- Notifications
- Support

Les données sont actuellement mockées afin de finaliser l'UX/UI avant connexion Laravel / PAWAPAY.

## Lot v3 — Auth & KYC local

Ajouts principaux :

- Inscription complète avec pays et opérateur Mobile Money.
- Vérification OTP à 6 chiffres.
- Mot de passe oublié.
- Parcours KYC complet : introduction, identité, adresse, document, selfie, résumé, état en attente.
- Nouveaux composants Design System : `OtpInput`, `ProgressStepper`, `AppEmptyState`.
- Routes GoRouter ajoutées pour tout le flux Auth/KYC.

> Cette version utilise encore des données fictives et ne contient pas d’appel backend.

## Version v4 — Module Transfert démo
Cette version ajoute un parcours de transfert entièrement navigable avec données fictives : choix du type, pays d'origine, bénéficiaire, montant, calcul des frais, confirmation PIN, traitement, succès et reçu.

## Version v5 — Historique & Bénéficiaires

Ajouts principaux :

- Historique alimenté par un `FakeHistoryDatasource`
- Modèle `ActivityTransactionModel`
- Providers Riverpod pour les transactions
- Liste d'activités dynamique
- Détail transaction
- Reçu visuel depuis l'historique
- Liste bénéficiaires connectée aux données fictives du module transfert
- Détail bénéficiaire avec statistiques et historique récent
- Formulaire d'ajout bénéficiaire
- Routes `/history/detail/:reference`, `/history/receipt/:reference`, `/beneficiaries/detail/:id`, `/beneficiaries/new`

Objectif : rendre cohérents les modules Transfert, Historique et Bénéficiaires avant de poursuivre vers Cartes virtuelles et Fidélité.

## Version v6 — Cartes virtuelles

Ajouts principaux :

- Modèles `VirtualCardModel` et `CardTransactionModel`
- `FakeCardsDatasource` + `CardsRepository`
- Providers Riverpod pour cartes, détail carte et transactions carte
- Écran Mes cartes avec liste dynamique
- Écran détail carte avec actions rapides
- Création de carte virtuelle avec devise et limite quotidienne
- Recharge de carte avec calcul de frais fictif
- Paramètres carte : limites, paiements en ligne, sécurité
- Blocage / déblocage simulé
- Routes `/cards/create`, `/cards/detail/:id`, `/cards/topup/:id`, `/cards/settings/:id`

Objectif : rendre le module Cartes virtuelles démontrable sans backend, avant de passer au Profil & Sécurité.

## V7 — Profil & Sécurité

Ajouts :
- Profil enrichi avec statistiques utilisateur
- Modification du profil
- Centre de sécurité avec score de protection
- Statut KYC et limites du compte
- Appareils connectés
- Paramètres de notifications
- Langue & devise préférée
- Parrainage
- Nouvelles routes `/profile/*`

### V7 - Profil & Sécurité
Le module Profil est maintenant enrichi avec des données fictives cohérentes : centre de confiance, sécurité, KYC, comptes Mobile Money, appareils connectés, journal de sécurité, notifications et préférences.

### V8 - Fidélité & Récompenses
Cette version ajoute le programme de fidélité MiangPay : points, niveaux, récompenses, défis actifs, historique et parrainage avancé, avec données fictives prêtes à remplacer par l'API Laravel.

### V9 - Promotions & Campagnes

Cette version ajoute le module Promotions & Campagnes Marketing avec données fictives : offres par corridor, coupons, campagnes actives et centre des économies.


## V10 - Notifications & Centre de messages

Ajouts de ce lot :
- centre de notifications avec filtres par catégorie ;
- notifications transactionnelles, sécurité, cartes, promotions, fidélité et support ;
- centre de messages avec conversations système/support/campagnes ;
- préférences de notifications ;
- fake datasource, repository et providers Riverpod ;
- widgets réutilisables `NotificationMessageCard`, `MessageThreadCard`, `NotificationSettingTile`.


## Version V11 — Front Office Flutter complet

Cette archive contient le frontend MiangPay complet en mode démo avec données fictives : Auth, KYC, Dashboard, Transfert, Historique, Bénéficiaires, Cartes, Profil, Fidélité, Promotions, Notifications, Support et États système.

### Lancer le projet

```bash
flutter pub get
flutter run
```

### Note

Aucun backend n'est requis pour cette version. Les données proviennent de fake datasources/repositories afin de valider l'expérience utilisateur avant l'intégration Laravel + PAWAPAY.
