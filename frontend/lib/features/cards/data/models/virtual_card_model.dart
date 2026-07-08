class VirtualCardModel {
  final String id;
  final String holderName;
  final String lastDigits;
  final String currency;
  final double balance;
  final String expiry;
  final bool isFrozen;
  final double dailyLimit;
  final double monthlyLimit;
  final bool onlinePaymentsEnabled;
  final String label;

  const VirtualCardModel({
    required this.id,
    required this.holderName,
    required this.lastDigits,
    required this.currency,
    required this.balance,
    required this.expiry,
    required this.isFrozen,
    required this.dailyLimit,
    required this.monthlyLimit,
    required this.onlinePaymentsEnabled,
    required this.label,
  });

  VirtualCardModel copyWith({
    double? balance,
    bool? isFrozen,
    double? dailyLimit,
    double? monthlyLimit,
    bool? onlinePaymentsEnabled,
    String? label,
  }) {
    return VirtualCardModel(
      id: id,
      holderName: holderName,
      lastDigits: lastDigits,
      currency: currency,
      balance: balance ?? this.balance,
      expiry: expiry,
      isFrozen: isFrozen ?? this.isFrozen,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      onlinePaymentsEnabled: onlinePaymentsEnabled ?? this.onlinePaymentsEnabled,
      label: label ?? this.label,
    );
  }
}
