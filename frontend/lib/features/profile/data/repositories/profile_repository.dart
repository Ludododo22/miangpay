import '../datasources/fake_profile_datasource.dart';
import '../models/mobile_money_account_model.dart';
import '../models/security_device_model.dart';
import '../models/security_log_model.dart';
import '../models/user_profile_model.dart';

class ProfileRepository {
  final FakeProfileDatasource datasource;

  ProfileRepository(this.datasource);

  Future<UserProfileModel> getProfile() => datasource.getProfile();
  Future<List<MobileMoneyAccountModel>> getMobileMoneyAccounts() => datasource.getMobileMoneyAccounts();
  Future<List<SecurityDeviceModel>> getDevices() => datasource.getDevices();
  Future<List<SecurityLogModel>> getSecurityLogs() => datasource.getSecurityLogs();
}
