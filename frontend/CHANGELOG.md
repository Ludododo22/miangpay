# Changelog MiangPay

## v5 — Historique & Bénéficiaires

- Ajout du datasource fictif d'historique.
- Ajout du modèle `ActivityTransactionModel`.
- Ajout des providers Riverpod d'historique.
- Remplacement de l'historique statique par une liste dynamique.
- Ajout du détail transaction.
- Ajout du reçu transaction depuis l'historique.
- Remplacement des bénéficiaires statiques par les bénéficiaires fictifs partagés avec le module Transfert.
- Ajout du détail bénéficiaire.
- Ajout du formulaire nouveau bénéficiaire.

## v4 — Module Transfert Démo

- Parcours transfert complet avec données fictives.
- Calcul frais simulé.
- Confirmation PIN.
- Traitement, succès et reçu.

## v6 - Cartes virtuelles

- Ajout du module Cartes virtuelles complet en mode démo.
- Ajout des fake data cartes et transactions carte.
- Ajout des écrans création, détail, recharge et paramètres.
- Ajout des providers Riverpod dédiés au module cartes.
- Mise à jour des routes GoRouter.

## V7 - Profil & Sécurité
- Ajout du hub Profil enrichi.
- Ajout Centre de confiance / score sécurité.
- Ajout gestion des comptes Mobile Money.
- Ajout centre de sécurité : PIN, biométrie, 2FA.
- Ajout appareils connectés et journal de sécurité.
- Ajout statut KYC, préférences langue/devise et paramètres notifications.
- Ajout fake datasource, repository et providers Riverpod pour le profil.

## V8 - Fidélité & Récompenses
- Ajout du module Fidélité complet avec données fictives.
- Ajout des niveaux Bronze, Argent, Or et Platine.
- Ajout de la boutique récompenses, défis, historique de points et parrainage.
- Ajout des providers Riverpod et repository fictif.
- Ajout des routes `/loyalty/*`.

## V9 - Promotions & Campagnes Marketing

- Ajout des modèles Promotion, Coupon et Campaign.
- Ajout du fake datasource et repository promotions.
- Ajout des providers Riverpod promotions, coupons et campagnes.
- Remplacement de l'écran Promotions par un centre complet d'offres.
- Ajout des écrans détail promotion, coupons, campagnes et centre des économies.
- Ajout des widgets PromotionOfferCard, CouponCard et CampaignCard.
- Mise à jour du routage `/promotions/*`.


## V10 - Notifications & Centre de messages

- Ajout du module `features/notifications/data`.
- Ajout des modèles `NotificationMessageModel`, `MessageThreadModel`, `NotificationSettingsModel`.
- Ajout des providers Riverpod pour notifications, messages et préférences.
- Remplacement de l'écran notifications statique par un centre de messages filtrable.
- Ajout des routes `/notifications/messages` et `/notifications/settings`.

## V11 — Frontend complet

- Finalisation du module Support : FAQ, Chat, Tickets, Nouveau ticket, Contact.
- Ajout de l’écran KYC refusé et reprise de vérification.
- Ajout des états système : Offline, Maintenance, Server Error, Update Required.
- Ajout du loader `AppSkeleton`.
- Mise à jour du routage GoRouter.
- Ajout de la checklist finale frontend.
