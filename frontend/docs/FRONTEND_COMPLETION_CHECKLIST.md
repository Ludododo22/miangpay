# MiangPay — Frontend Flutter V11 terminé

Cette version finalise le Front Office Flutter avec données fictives.

## Modules couverts

- Splash / Onboarding / Choix pays
- Authentification : login, inscription, OTP, mot de passe oublié
- KYC : introduction, informations, adresse, document, selfie, revue, attente, refus
- Dashboard principal
- Transfert complet : pays, opérateur, bénéficiaire, montant, frais, PIN, traitement, succès, reçu
- Bénéficiaires : liste, ajout, détail
- Historique : transactions, détail, reçu
- Cartes virtuelles : liste, création, détail, recharge, paramètres
- Profil & Sécurité : profil, centre de confiance, appareils, journal, préférences
- Fidélité & Récompenses : points, niveaux, défis, boutique, parrainage
- Promotions & Campagnes : offres, coupons, campagnes, économies
- Notifications & Messages : centre filtrable, messages, réglages
- Support : FAQ, chat, tickets, nouveau ticket, contacts
- États système : hors ligne, maintenance, serveur indisponible, mise à jour obligatoire

## Architecture

- Flutter + Riverpod + GoRouter
- Design System centralisé
- Fake repositories/datasources par module
- Navigation complète sans backend
- Structure prête pour remplacement des fake services par Laravel

## Prochaine phase recommandée

1. Revue visuelle dans Flutter.
2. Correction fine responsive/accessibilité.
3. Initialisation backend Laravel.
4. Remplacement progressif des fake repositories par API repositories.
