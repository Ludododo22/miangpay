import 'loyalty_activity_model.dart';
import 'loyalty_challenge_model.dart';
import 'loyalty_tier_model.dart';
import 'reward_model.dart';

class LoyaltyOverviewModel {
  final int points;
  final String currentTier;
  final int nextTierPoints;
  final int referrals;
  final String referralCode;
  final List<LoyaltyTierModel> tiers;
  final List<RewardModel> rewards;
  final List<LoyaltyChallengeModel> challenges;
  final List<LoyaltyActivityModel> activities;

  const LoyaltyOverviewModel({
    required this.points,
    required this.currentTier,
    required this.nextTierPoints,
    required this.referrals,
    required this.referralCode,
    required this.tiers,
    required this.rewards,
    required this.challenges,
    required this.activities,
  });
}
