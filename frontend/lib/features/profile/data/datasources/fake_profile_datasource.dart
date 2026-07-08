import '../models/mobile_money_account_model.dart';
import '../models/security_device_model.dart';
import '../models/security_log_model.dart';
import '../models/user_profile_model.dart';

class FakeProfileDatasource {
  Future<UserProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const UserProfileModel(
      id: 'USR-001',
      fullName: 'Jean Dupont',
      initials: 'JD',
      country: 'Bénin',
      flag: '🇧🇯',
      phone: '+229 97 00 00 00',
      email: 'jean.dupont@miangpay.demo',
      operatorName: 'MTN Mobile Money',
      kycStatus: 'Vérifié',
      tier: 'Or',
      loyaltyPoints: 2150,
      securityScore: 92,
    );
  }

  Future<List<MobileMoneyAccountModel>> getMobileMoneyAccounts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      MobileMoneyAccountModel(country: 'Bénin', flag: '🇧🇯', operatorName: 'MTN Mobile Money', phone: '+229 97 00 00 00', primary: true),
      MobileMoneyAccountModel(country: 'Bénin', flag: '🇧🇯', operatorName: 'Moov Money', phone: '+229 66 00 00 00'),
      MobileMoneyAccountModel(country: 'Côte d’Ivoire', flag: '🇨🇮', operatorName: 'Orange Money', phone: '+225 07 00 00 00'),
    ];
  }

  Future<List<SecurityDeviceModel>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 220));
    return const [
      SecurityDeviceModel(id: 'DEV-1', name: 'iPhone 15 Pro', location: 'Cotonou, Bénin', lastActive: 'Actif maintenant', current: true),
      SecurityDeviceModel(id: 'DEV-2', name: 'Chrome Windows', location: 'Porto-Novo, Bénin', lastActive: 'Hier à 18:42'),
      SecurityDeviceModel(id: 'DEV-3', name: 'Samsung Galaxy A54', location: 'Abidjan, Côte d’Ivoire', lastActive: '12 juin 2026'),
    ];
  }

  Future<List<SecurityLogModel>> getSecurityLogs() async {
    await Future.delayed(const Duration(milliseconds: 220));
    return const [
      SecurityLogModel(title: 'Connexion réussie', description: 'iPhone 15 Pro • Cotonou', date: 'Aujourd’hui, 09:35', type: 'login'),
      SecurityLogModel(title: 'PIN modifié', description: 'Votre code PIN a été mis à jour', date: 'Hier, 21:10', type: 'pin'),
      SecurityLogModel(title: 'Nouvelle carte créée', description: 'Carte virtuelle XOF', date: '04 juillet 2026', type: 'card'),
      SecurityLogModel(title: 'KYC vérifié', description: 'Votre identité a été validée', date: '01 juillet 2026', type: 'kyc'),
    ];
  }
}
