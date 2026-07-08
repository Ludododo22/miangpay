import '../../../transfer/data/datasources/fake_transfer_datasource.dart';
import '../models/activity_transaction_model.dart';

class FakeHistoryDatasource {
  final FakeTransferDatasource _transferDatasource = FakeTransferDatasource();

  Future<List<ActivityTransactionModel>> getTransactions() async {
    final beneficiaries = await _transferDatasource.getBeneficiaries();
    final countries = await _transferDatasource.getCountries();
    final now = DateTime.now();

    return List.generate(18, (index) {
      final beneficiary = beneficiaries[index % beneficiaries.length];
      final sourceCountry = countries[(index + 1) % countries.length];
      final amount = [15000, 25000, 50000, 75000, 100000][index % 5].toDouble();
      final fee = amount * (sourceCountry.code == beneficiary.country.code ? 0.015 : 0.025);
      final status = index % 7 == 0 ? 'pending' : index % 11 == 0 ? 'failed' : 'success';
      return ActivityTransactionModel(
        reference: 'MP2026${1000 + index}',
        type: index % 4 == 0 ? 'card' : 'send',
        beneficiary: beneficiary,
        sourceCountry: sourceCountry,
        amount: amount,
        fee: fee,
        receivedAmount: amount - fee,
        currency: sourceCountry.currency,
        status: status,
        createdAt: now.subtract(Duration(hours: index * 5, days: index ~/ 4)),
      );
    });
  }
}
