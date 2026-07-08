class CouponModel {
  final String code;
  final String label;
  final String benefit;
  final String expiry;
  final bool used;

  const CouponModel({
    required this.code,
    required this.label,
    required this.benefit,
    required this.expiry,
    this.used = false,
  });
}
