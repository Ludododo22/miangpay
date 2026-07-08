class LoyaltyTierModel {
  final String id;
  final String name;
  final int minPoints;
  final int? maxPoints;
  final String description;
  final double feeDiscount;
  final int freeTransfers;
  final String icon;

  const LoyaltyTierModel({
    required this.id,
    required this.name,
    required this.minPoints,
    this.maxPoints,
    required this.description,
    required this.feeDiscount,
    required this.freeTransfers,
    required this.icon,
  });
}
