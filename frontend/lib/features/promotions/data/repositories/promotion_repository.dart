import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../datasources/fake_promotion_datasource.dart';
import '../models/campaign_model.dart';
import '../models/coupon_model.dart';
import '../models/promotion_model.dart';

class PromotionRepository {
  final FakePromotionDatasource datasource;
  final ApiClient? _client;

  PromotionRepository(this.datasource) : _client = null;
  PromotionRepository.api(ApiClient client)
      : datasource = FakePromotionDatasource(),
        _client = client;

  Future<List<PromotionModel>> getPromotions() async {
    final client = _client;
    if (client == null) return datasource.getPromotions();

    final json = await client.getJson('/promotions/active');
    return ApiJson.dataList(json).map(_promotionFromJson).toList();
  }

  Future<List<CouponModel>> getCoupons() async {
    final client = _client;
    if (client == null) return datasource.getCoupons();

    final json = await client.getJson('/promotions/active');
    return ApiJson.dataList(json)
        .where((item) => ApiJson.string(item['code']).isNotEmpty)
        .map(_couponFromJson)
        .toList();
  }

  Future<List<CampaignModel>> getCampaigns() => datasource.getCampaigns();

  PromotionModel _promotionFromJson(Map<String, dynamic> json) {
    final countryCode =
        ApiJson.string(json['target_country_code'], fallback: 'Tous');
    final discount =
        ApiJson.decimal(json['discount_percent']).toStringAsFixed(0);
    return PromotionModel(
      id: ApiJson.string(json['id']),
      title: ApiJson.string(json['title']),
      description: ApiJson.string(json['description']),
      tag: '-$discount%',
      category: 'Frais',
      corridor: countryCode,
      expiresAt: _dateLabel(ApiJson.date(json['expires_at'])),
      remainingUses: 999,
      isFeatured: true,
    );
  }

  CouponModel _couponFromJson(Map<String, dynamic> json) {
    final discount =
        ApiJson.decimal(json['discount_percent']).toStringAsFixed(0);
    return CouponModel(
      code: ApiJson.string(json['code']),
      label: ApiJson.string(json['title']),
      benefit: '-$discount% sur les frais',
      expiry: _dateLabel(ApiJson.date(json['expires_at'])),
    );
  }

  String _dateLabel(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  }
}
