class MobileMoneyAccountModel {
  final String country;
  final String flag;
  final String operatorName;
  final String phone;
  final bool primary;

  const MobileMoneyAccountModel({
    required this.country,
    required this.flag,
    required this.operatorName,
    required this.phone,
    this.primary = false,
  });
}
