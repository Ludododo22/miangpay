import '../models/campaign_model.dart';
import '../models/coupon_model.dart';
import '../models/promotion_model.dart';

class FakePromotionDatasource {
  Future<List<PromotionModel>> getPromotions() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const [
      PromotionModel(id: 'p1', title: 'Gabon → Bénin', description: 'Réduction exceptionnelle sur les frais de transfert.', tag: '-50%', category: 'Corridor', corridor: 'GA → BJ', expiresAt: 'Aujourd’hui', remainingUses: 2, isFeatured: true),
      PromotionModel(id: 'p2', title: 'Semaine Sénégal', description: 'Envoyez vers Orange Money Sénégal avec frais réduits.', tag: '-30%', category: 'Pays', corridor: 'Tous → SN', expiresAt: '30 juillet', remainingUses: 4),
      PromotionModel(id: 'p3', title: 'Points doublés', description: 'Gagnez deux fois plus de points sur vos 3 prochains transferts.', tag: 'x2', category: 'Fidélité', corridor: 'Tous', expiresAt: 'Dimanche', remainingUses: 3),
      PromotionModel(id: 'p4', title: 'Carte virtuelle', description: 'Rechargez votre carte et recevez un bonus de points.', tag: '+500 pts', category: 'Cartes', corridor: 'Mobile Money', expiresAt: '15 août', remainingUses: 1),
      PromotionModel(id: 'p5', title: 'Premier transfert Mali', description: 'Bonus pour votre premier transfert vers le Mali.', tag: '+20%', category: 'Nouveau pays', corridor: 'Tous → ML', expiresAt: 'Cette semaine', remainingUses: 1),
    ];
  }

  Future<List<CouponModel>> getCoupons() async {
    return const [
      CouponModel(code: 'MIANG15', label: 'Bienvenue MiangPay', benefit: '-15% sur un transfert', expiry: 'Expire dans 5 jours'),
      CouponModel(code: 'OR2026', label: 'Bonus niveau Or', benefit: '1 transfert gratuit', expiry: 'Expire dans 12 jours'),
      CouponModel(code: 'CARD500', label: 'Recharge carte', benefit: '+500 points', expiry: 'Utilisé', used: true),
    ];
  }

  Future<List<CampaignModel>> getCampaigns() async {
    return const [
      CampaignModel(id: 'c1', title: 'Semaine de la Diaspora', description: 'Effectuez 3 transferts vers vos proches et débloquez des frais réduits.', progress: 70, reward: '-30% + points doublés', timeLeft: '4 jours'),
      CampaignModel(id: 'c2', title: 'Challenge Afrique de l’Ouest', description: 'Envoyez vers 3 pays différents pour obtenir un badge exclusif.', progress: 45, reward: '+1000 points', timeLeft: '9 jours'),
    ];
  }
}
