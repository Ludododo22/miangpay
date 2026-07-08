import '../models/loyalty_activity_model.dart';
import '../models/loyalty_challenge_model.dart';
import '../models/loyalty_tier_model.dart';
import '../models/reward_model.dart';

class FakeLoyaltyDatasource {
  int get points => 2150;
  String get currentTier => 'Or';
  int get nextTierPoints => 3000;
  int get referrals => 8;
  String get referralCode => 'MIANG2026';

  List<LoyaltyTierModel> get tiers => const [
    LoyaltyTierModel(id: 'bronze', name: 'Bronze', minPoints: 0, maxPoints: 499, description: 'Compte standard avec avantages de base', feeDiscount: 10, freeTransfers: 0, icon: '🥉'),
    LoyaltyTierModel(id: 'silver', name: 'Argent', minPoints: 500, maxPoints: 1999, description: 'Frais réduits et 1 transfert gratuit/mois', feeDiscount: 25, freeTransfers: 1, icon: '🥈'),
    LoyaltyTierModel(id: 'gold', name: 'Or', minPoints: 2000, maxPoints: 4999, description: 'Frais fortement réduits et support prioritaire', feeDiscount: 50, freeTransfers: 2, icon: '🥇'),
    LoyaltyTierModel(id: 'platinum', name: 'Platine', minPoints: 5000, description: 'Support VIP, offres exclusives et frais minimum', feeDiscount: 75, freeTransfers: 3, icon: '💎'),
  ];

  List<RewardModel> get rewards => const [
    RewardModel(id: 'r1', title: '1 transfert gratuit', description: 'À utiliser sur un corridor actif', pointsCost: 500, category: 'Transfert'),
    RewardModel(id: 'r2', title: '-25% sur les frais', description: 'Réduction immédiate sur le prochain envoi', pointsCost: 1000, category: 'Frais'),
    RewardModel(id: 'r3', title: 'Carte virtuelle gratuite', description: 'Création d’une carte sans frais', pointsCost: 3000, category: 'Carte'),
    RewardModel(id: 'r4', title: 'Bonus Mobile Money', description: 'Recevez 2 000 XOF de bonus', pointsCost: 5000, category: 'Bonus', available: false),
  ];

  List<LoyaltyChallengeModel> get challenges => const [
    LoyaltyChallengeModel(id: 'c1', title: '5 transferts cette semaine', description: 'Effectuez 5 transferts pour gagner des points bonus', rewardPoints: 150, progress: 3, target: 5, deadline: 'Expire dimanche'),
    LoyaltyChallengeModel(id: 'c2', title: '3 pays différents', description: 'Envoyez vers 3 pays africains différents', rewardPoints: 300, progress: 2, target: 3, deadline: 'Encore 10 jours'),
    LoyaltyChallengeModel(id: 'c3', title: 'Parrainer 2 amis', description: 'Invitez 2 amis et gagnez des points', rewardPoints: 500, progress: 1, target: 2, deadline: 'Ce mois-ci'),
  ];

  List<LoyaltyActivityModel> get activities => [
    LoyaltyActivityModel(id: 'a1', title: 'Transfert vers Ahmed', source: 'Transfert', points: 120, date: DateTime.now()),
    LoyaltyActivityModel(id: 'a2', title: 'Parrainage validé', source: 'Parrainage', points: 500, date: DateTime.now().subtract(const Duration(days: 1))),
    LoyaltyActivityModel(id: 'a3', title: 'Défi hebdomadaire', source: 'Défi', points: 150, date: DateTime.now().subtract(const Duration(days: 3))),
    LoyaltyActivityModel(id: 'a4', title: 'Transfert Côte d’Ivoire', source: 'Transfert', points: 80, date: DateTime.now().subtract(const Duration(days: 8))),
  ];
}
