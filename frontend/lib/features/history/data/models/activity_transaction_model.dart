import '../../../transfer/data/models/beneficiary_model.dart';
import '../../../transfer/data/models/country_model.dart';

class ActivityTransactionModel {
  final String reference;
  final String type;
  final BeneficiaryModel beneficiary;
  final CountryModel sourceCountry;
  final double amount;
  final double fee;
  final double receivedAmount;
  final String currency;
  final String status;
  final DateTime createdAt;

  const ActivityTransactionModel({
    required this.reference,
    required this.type,
    required this.beneficiary,
    required this.sourceCountry,
    required this.amount,
    required this.fee,
    required this.receivedAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  String get corridor => '${sourceCountry.code} → ${beneficiary.country.code}';
  String get operatorName => beneficiary.operator.name;
}
