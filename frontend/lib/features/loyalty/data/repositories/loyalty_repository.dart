import '../datasources/fake_loyalty_datasource.dart';
import '../models/loyalty_activity_model.dart';
import '../models/loyalty_challenge_model.dart';
import '../models/loyalty_tier_model.dart';
import '../models/reward_model.dart';

class LoyaltyRepository {
  LoyaltyRepository(this._datasource);
  final FakeLoyaltyDatasource _datasource;

  int get points => _datasource.points;
  String get currentTier => _datasource.currentTier;
  int get nextTierPoints => _datasource.nextTierPoints;
  int get referrals => _datasource.referrals;
  String get referralCode => _datasource.referralCode;
  List<LoyaltyTierModel> get tiers => _datasource.tiers;
  List<RewardModel> get rewards => _datasource.rewards;
  List<LoyaltyChallengeModel> get challenges => _datasource.challenges;
  List<LoyaltyActivityModel> get activities => _datasource.activities;
}
