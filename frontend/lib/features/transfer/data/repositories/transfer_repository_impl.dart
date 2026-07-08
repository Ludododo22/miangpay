import '../datasources/fake_transfer_datasource.dart';
import '../models/beneficiary_model.dart';
import '../models/country_model.dart';
import '../models/fee_quote_model.dart';
import '../models/operator_model.dart';
import '../models/receipt_model.dart';

class TransferRepositoryImpl {
  final FakeTransferDatasource datasource;

  TransferRepositoryImpl(this.datasource);

  Future<List<CountryModel>> getCountries() => datasource.getCountries();
  Future<List<OperatorModel>> getOperators(String countryCode) => datasource.getOperators(countryCode);
  Future<List<BeneficiaryModel>> getBeneficiaries() => datasource.getBeneficiaries();
  Future<FeeQuoteModel> calculateFee({required double amount, required CountryModel sourceCountry, required CountryModel destinationCountry}) {
    return datasource.calculateFee(amount: amount, sourceCountry: sourceCountry, destinationCountry: destinationCountry);
  }
  Future<ReceiptModel> submitTransfer({required BeneficiaryModel beneficiary, required CountryModel sourceCountry, required FeeQuoteModel quote}) {
    return datasource.submitTransfer(beneficiary: beneficiary, sourceCountry: sourceCountry, quote: quote);
  }
}
