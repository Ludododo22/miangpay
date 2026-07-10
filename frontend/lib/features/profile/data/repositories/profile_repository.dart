import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../datasources/fake_profile_datasource.dart';
import '../models/mobile_money_account_model.dart';
import '../models/security_device_model.dart';
import '../models/security_log_model.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  final FakeProfileDatasource datasource;
  final ApiClient? _client;

  ProfileRepository(this.datasource) : _client = null;
  ProfileRepository.api(ApiClient client)
      : datasource = FakeProfileDatasource(),
        _client = client;

  Future<UserProfileModel> getProfile() async {
    final client = _client;
    if (client == null) return datasource.getProfile();

    final json = await client.getJson('/user/profile');
    return _profileFromJson(ApiJson.dataMap(json));
  }

  Future<List<MobileMoneyAccountModel>> getMobileMoneyAccounts() =>
      datasource.getMobileMoneyAccounts();
  Future<List<SecurityDeviceModel>> getDevices() => datasource.getDevices();
  Future<List<SecurityLogModel>> getSecurityLogs() =>
      datasource.getSecurityLogs();

  UserProfileModel _profileFromJson(Map<String, dynamic> json) {
    final firstName = ApiJson.string(json['first_name']);
    final lastName = ApiJson.string(json['last_name']);
    final fullName = '$firstName $lastName'.trim();
    return UserProfileModel(
      id: ApiJson.string(json['id']),
      fullName: fullName.isEmpty ? 'Utilisateur MiangPay' : fullName,
      initials: _initials(fullName),
      country: ApiJson.string(json['country_name'], fallback: 'Benin'),
      flag: ApiJson.string(json['flag_emoji']),
      phone: ApiJson.string(json['phone']),
      email: ApiJson.string(json['email'],
          fallback: 'non-renseigne@miangpay.local'),
      operatorName: 'Mobile Money',
      kycStatus: ApiJson.string(json['kyc_status'], fallback: 'pending'),
      tier: ApiJson.string(json['loyalty_tier'], fallback: 'Bronze'),
      loyaltyPoints: ApiJson.integer(json['loyalty_points']),
      securityScore: 92,
    );
  }

  String _initials(String fullName) {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final value = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return value.isEmpty ? 'MP' : value;
  }
}
