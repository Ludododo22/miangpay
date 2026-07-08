import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/fake_loyalty_datasource.dart';
import '../../data/repositories/loyalty_repository.dart';

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  return LoyaltyRepository(FakeLoyaltyDatasource());
});

final loyaltyPointsProvider = Provider<int>((ref) => ref.watch(loyaltyRepositoryProvider).points);
final loyaltyTiersProvider = Provider((ref) => ref.watch(loyaltyRepositoryProvider).tiers);
final rewardsProvider = Provider((ref) => ref.watch(loyaltyRepositoryProvider).rewards);
final loyaltyChallengesProvider = Provider((ref) => ref.watch(loyaltyRepositoryProvider).challenges);
final loyaltyActivitiesProvider = Provider((ref) => ref.watch(loyaltyRepositoryProvider).activities);
