import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/fake_loyalty_datasource.dart';
import '../../data/models/loyalty_overview_model.dart';
import '../../data/repositories/loyalty_repository.dart';

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  if (ref.watch(dataSourceModeProvider) == DataSourceMode.api) {
    return LoyaltyRepository.api(ref.watch(apiClientProvider));
  }
  return LoyaltyRepository(FakeLoyaltyDatasource());
});

final loyaltyOverviewProvider = FutureProvider<LoyaltyOverviewModel>((ref) {
  return ref.watch(loyaltyRepositoryProvider).getOverview();
});
