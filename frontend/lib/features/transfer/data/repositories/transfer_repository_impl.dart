import '../datasources/fake_transfer_datasource.dart';
import '../models/beneficiary_model.dart';
import '../models/country_model.dart';
import '../models/fee_quote_model.dart';
import '../models/operator_model.dart';
import '../models/receipt_model.dart';
import 'transfer_repository.dart';

class TransferRepositoryImpl implements TransferRepository {
  final FakeTransferDatasource datasource;

  TransferRepositoryImpl(this.datasource);

  @override
  Future<List<CountryModel>> getCountries() => datasource.getCountries();

  @override
  Future<List<OperatorModel>> getOperators(String countryCode) =>
      datasource.getOperators(countryCode);

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() =>
      datasource.getBeneficiaries();

  @override
  Future<FeeQuoteModel> calculateFee(
      {required double amount,
      required CountryModel sourceCountry,
      required CountryModel destinationCountry}) {
    return datasource.calculateFee(
        amount: amount,
        sourceCountry: sourceCountry,
        destinationCountry: destinationCountry);
  }

  @override
  Future<ReceiptModel> submitTransfer(
      {required BeneficiaryModel beneficiary,
      required CountryModel sourceCountry,
      required FeeQuoteModel quote}) {
    return datasource.submitTransfer(
        beneficiary: beneficiary, sourceCountry: sourceCountry, quote: quote);
  }
}
