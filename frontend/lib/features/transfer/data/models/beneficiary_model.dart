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
}
