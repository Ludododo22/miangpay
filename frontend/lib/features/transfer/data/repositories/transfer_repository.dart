import '../models/beneficiary_model.dart';
import '../models/country_model.dart';
import '../models/fee_quote_model.dart';
import '../models/operator_model.dart';
import '../models/receipt_model.dart';

abstract class TransferRepository {
  Future<List<CountryModel>> getCountries();

  Future<List<OperatorModel>> getOperators(String countryCode);

  Future<List<BeneficiaryModel>> getBeneficiaries();

  Future<FeeQuoteModel> calculateFee({
    required double amount,
    required CountryModel sourceCountry,
    required CountryModel destinationCountry,
  });

  Future<ReceiptModel> submitTransfer({
    required BeneficiaryModel beneficiary,
    required CountryModel sourceCountry,
    required FeeQuoteModel quote,
  });
}
