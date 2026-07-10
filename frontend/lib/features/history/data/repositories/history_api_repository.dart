import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../../../transfer/data/models/beneficiary_model.dart';
import '../../../transfer/data/models/country_model.dart';
import '../../../transfer/data/models/operator_model.dart';
import '../models/activity_transaction_model.dart';

class HistoryApiRepository {
  const HistoryApiRepository(this._client);

  final ApiClient _client;

  Future<List<ActivityTransactionModel>> getTransactions() async {
    final json = await _client.getJson('/transfer/history');
    return ApiJson.dataList(json).map(_transactionFromJson).toList();
  }

  ActivityTransactionModel _transactionFromJson(Map<String, dynamic> json) {
    final sourceCountry = CountryModel(
      code: ApiJson.string(json['origin_code']),
      name: ApiJson.string(json['origin_name']),
      flag: '',
      currency: ApiJson.string(json['currency'], fallback: 'XOF'),
      phoneCode: '',
    );
    final destinationCountry = CountryModel(
      code: ApiJson.string(json['destination_code']),
      name: ApiJson.string(json['destination_name']),
      flag: '',
      currency: ApiJson.string(json['destination_currency'], fallback: 'XOF'),
      phoneCode: '',
    );
    final operator = OperatorModel(
      id: ApiJson.string(json['operator_id']),
      name: ApiJson.string(json['operator_name'], fallback: 'Mobile Money'),
      countryCode: destinationCountry.code,
      serviceCode: '',
    );
    final beneficiary = BeneficiaryModel(
      id: ApiJson.string(json['beneficiary_id']),
      fullName:
          ApiJson.string(json['beneficiary_name'], fallback: 'Beneficiaire'),
      phone: '',
      country: destinationCountry,
      operator: operator,
      isFavorite: false,
      initials: _initials(ApiJson.string(json['beneficiary_name'])),
    );

    return ActivityTransactionModel(
      reference: ApiJson.string(json['reference']),
      type: 'send',
      beneficiary: beneficiary,
      sourceCountry: sourceCountry,
      amount: ApiJson.decimal(json['amount']),
      fee: ApiJson.decimal(json['fee']),
      receivedAmount: ApiJson.decimal(json['received_amount']),
      currency: ApiJson.string(json['currency'], fallback: 'XOF'),
      status: _status(ApiJson.string(json['status'])),
      createdAt: ApiJson.date(json['created_at']),
    );
  }

  String _status(String status) {
    return switch (status) {
      'completed' => 'success',
      'failed' => 'failed',
      _ => 'pending',
    };
  }

  String _initials(String fullName) {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final value = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return value.isEmpty ? '?' : value;
  }
}
