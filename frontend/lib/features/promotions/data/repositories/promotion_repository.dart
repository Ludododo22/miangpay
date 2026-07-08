import '../datasources/fake_promotion_datasource.dart';
import '../models/campaign_model.dart';
import '../models/coupon_model.dart';
import '../models/promotion_model.dart';

class PromotionRepository {
  final FakePromotionDatasource datasource;

  PromotionRepository(this.datasource);

  Future<List<PromotionModel>> getPromotions() => datasource.getPromotions();
  Future<List<CouponModel>> getCoupons() => datasource.getCoupons();
  Future<List<CampaignModel>> getCampaigns() => datasource.getCampaigns();
}
