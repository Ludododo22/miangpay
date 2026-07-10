import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/fake_promotion_datasource.dart';
import '../../data/models/campaign_model.dart';
import '../../data/models/coupon_model.dart';
import '../../data/models/promotion_model.dart';
import '../../data/repositories/promotion_repository.dart';

final promotionRepositoryProvider = Provider<PromotionRepository>((ref) {
  if (ref.watch(dataSourceModeProvider) == DataSourceMode.api) {
    return PromotionRepository.api(ref.watch(apiClientProvider));
  }
  return PromotionRepository(FakePromotionDatasource());
});

final promotionsProvider = FutureProvider<List<PromotionModel>>((ref) {
  return ref.watch(promotionRepositoryProvider).getPromotions();
});

final couponsProvider = FutureProvider<List<CouponModel>>((ref) {
  return ref.watch(promotionRepositoryProvider).getCoupons();
});

final campaignsProvider = FutureProvider<List<CampaignModel>>((ref) {
  return ref.watch(promotionRepositoryProvider).getCampaigns();
});
