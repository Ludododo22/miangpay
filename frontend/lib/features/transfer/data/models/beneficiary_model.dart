import 'country_model.dart';
import 'operator_model.dart';

class BeneficiaryModel {
  final String id;
  final String fullName;
  final String phone;
  final CountryModel country;
  final OperatorModel operator;
  final bool isFavorite;
  final String initials;

  const BeneficiaryModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.country,
    required this.operator,
    required this.isFavorite,
    required this.initials,
  });

  BeneficiaryModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    CountryModel? country,
    OperatorModel? operator,
    bool? isFavorite,
    String? initials,
  }) {
    return BeneficiaryModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      operator: operator ?? this.operator,
      isFavorite: isFavorite ?? this.isFavorite,
      initials: initials ?? this.initials,
    );
  }
}
