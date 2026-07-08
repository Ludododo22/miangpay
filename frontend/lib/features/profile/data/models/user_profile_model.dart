class UserProfileModel {
  final String id;
  final String fullName;
  final String initials;
  final String country;
  final String flag;
  final String phone;
  final String email;
  final String operatorName;
  final String kycStatus;
  final String tier;
  final int loyaltyPoints;
  final int securityScore;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.initials,
    required this.country,
    required this.flag,
    required this.phone,
    required this.email,
    required this.operatorName,
    required this.kycStatus,
    required this.tier,
    required this.loyaltyPoints,
    required this.securityScore,
  });
}
