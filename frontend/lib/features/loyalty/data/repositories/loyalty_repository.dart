import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../datasources/fake_loyalty_datasource.dart';
import '../models/loyalty_activity_model.dart';
import '../models/loyalty_challenge_model.dart';
import '../models/loyalty_overview_model.dart';
import '../models/loyalty_tier_model.dart';
import '../models/reward_model.dart';

class LoyaltyRepository {
  LoyaltyRepository(this._datasource) : _client = null;
  LoyaltyRepository.api(ApiClient client)
      : _datasource = FakeLoyaltyDatasource(),
        _client = client;

  final FakeLoyaltyDatasource _datasource;
  final ApiClient? _client;

  int get points => _datasource.points;
  String get currentTier => _datasource.currentTier;
  int get nextTierPoints => _datasource.nextTierPoints;
  int get referrals => _datasource.referrals;
  String get referralCode => _datasource.referralCode;
  List<LoyaltyTierModel> get tiers => _datasource.tiers;
  List<RewardModel> get rewards => _datasource.rewards;
  List<LoyaltyChallengeModel> get challenges => _datasource.challenges;
  List<LoyaltyActivityModel> get activities => _datasource.activities;

  Future<LoyaltyOverviewModel> getOverview() async {
    final client = _client;
    if (client == null) {
      return LoyaltyOverviewModel(
        points: points,
        currentTier: currentTier,
        nextTierPoints: nextTierPoints,
        referrals: referrals,
        referralCode: referralCode,
        tiers: tiers,
        rewards: rewards,
        challenges: challenges,
        activities: activities,
      );
    }

    final json = await client.getJson('/loyalty/overview');
    final data = ApiJson.dataMap(json);
    return LoyaltyOverviewModel(
      points: ApiJson.integer(data['points']),
      currentTier: ApiJson.string(data['tier'], fallback: 'Bronze'),
      nextTierPoints: ApiJson.integer(data['next_tier_points']),
      referrals: ApiJson.integer(data['referrals']),
      referralCode: ApiJson.string(data['referral_code'], fallback: 'MIANGPAY'),
      tiers: ApiJson.list(data, 'tiers').map(_tierFromJson).toList(),
      rewards: ApiJson.list(data, 'rewards').map(_rewardFromJson).toList(),
      challenges:
          ApiJson.list(data, 'challenges').map(_challengeFromJson).toList(),
      activities:
          ApiJson.list(data, 'activities').map(_activityFromJson).toList(),
    );
  }

  LoyaltyTierModel _tierFromJson(Map<String, dynamic> json) {
    return LoyaltyTierModel(
      id: ApiJson.string(json['id']),
      name: ApiJson.string(json['name']),
      minPoints: ApiJson.integer(json['min_points']),
      maxPoints: json['max_points'] == null
          ? null
          : ApiJson.integer(json['max_points']),
      description: ApiJson.string(json['description']),
      feeDiscount: ApiJson.decimal(json['fee_discount']),
      freeTransfers: ApiJson.integer(json['free_transfers']),
      icon: ApiJson.string(json['icon']),
    );
  }

  RewardModel _rewardFromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: ApiJson.string(json['id']),
      title: ApiJson.string(json['title']),
      description: ApiJson.string(json['description']),
      pointsCost: ApiJson.integer(json['points_cost']),
      category: ApiJson.string(json['category']),
      available: ApiJson.boolean(json['available'], fallback: true),
    );
  }

  LoyaltyChallengeModel _challengeFromJson(Map<String, dynamic> json) {
    return LoyaltyChallengeModel(
      id: ApiJson.string(json['id']),
      title: ApiJson.string(json['title']),
      description: ApiJson.string(json['description']),
      rewardPoints: ApiJson.integer(json['reward_points']),
      progress: ApiJson.integer(json['progress']),
      target: ApiJson.integer(json['target']),
      deadline: ApiJson.string(json['deadline']),
    );
  }

  LoyaltyActivityModel _activityFromJson(Map<String, dynamic> json) {
    return LoyaltyActivityModel(
      id: ApiJson.string(json['id']),
      title: ApiJson.string(json['label'],
          fallback: ApiJson.string(json['title'])),
      source: ApiJson.string(json['activity_type'], fallback: 'Fidelite'),
      points: ApiJson.integer(json['points']),
      date: ApiJson.date(json['created_at']),
    );
  }
}
