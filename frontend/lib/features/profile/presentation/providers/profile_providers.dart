import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/fake_profile_datasource.dart';
import '../../data/models/mobile_money_account_model.dart';
import '../../data/models/security_device_model.dart';
import '../../data/models/security_log_model.dart';
import '../../data/models/user_profile_model.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(FakeProfileDatasource());
});

final userProfileProvider = FutureProvider<UserProfileModel>((ref) {
  return ref.watch(profileRepositoryProvider).getProfile();
});

final mobileMoneyAccountsProvider = FutureProvider<List<MobileMoneyAccountModel>>((ref) {
  return ref.watch(profileRepositoryProvider).getMobileMoneyAccounts();
});

final securityDevicesProvider = FutureProvider<List<SecurityDeviceModel>>((ref) {
  return ref.watch(profileRepositoryProvider).getDevices();
});

final securityLogsProvider = FutureProvider<List<SecurityLogModel>>((ref) {
  return ref.watch(profileRepositoryProvider).getSecurityLogs();
});

final biometricEnabledProvider = StateProvider<bool>((ref) => true);
final pinEnabledProvider = StateProvider<bool>((ref) => true);
final twoFactorEnabledProvider = StateProvider<bool>((ref) => true);
final transactionNotificationsProvider = StateProvider<bool>((ref) => true);
final promotionNotificationsProvider = StateProvider<bool>((ref) => false);
final loyaltyNotificationsProvider = StateProvider<bool>((ref) => true);
final marketingNotificationsProvider = StateProvider<bool>((ref) => false);
