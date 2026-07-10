import '../../../../core/api/api_client.dart';
import '../models/beneficiary_model.dart';
import '../models/country_model.dart';
import '../models/fee_quote_model.dart';
import '../models/operator_model.dart';
import '../models/receipt_model.dart';
import 'transfer_repository.dart';

class TransferApiRepository implements TransferRepository {
  const TransferApiRepository(this._client);

  final ApiClient _client;

  @override
  Future<List<CountryModel>> getCountries() async {
    final json = await _client.getJson('/countries');
    return _dataList(json).map(_countryFromJson).toList();
  }

  @override
  Future<List<OperatorModel>> getOperators(String countryCode) async {
    final json = await _client.getJson('/operators/$countryCode');
    return _dataList(json)
        .map((item) => _operatorFromJson(item, countryCode))
        .toList();
  }

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    final json = await _client.getJson('/beneficiaries');
    return _dataList(json).map(_beneficiaryFromJson).toList();
  }

  @override
  Future<BeneficiaryModel> createBeneficiary({
    required String fullName,
    required String phone,
    required CountryModel country,
    required OperatorModel operator,
    required bool isFavorite,
  }) async {
    final json = await _client.postJson(
      '/beneficiaries',
      data: {
        'full_name': fullName,
        'phone': phone,
        'country_code': country.code,
        'operator_code': operator.id,
        'is_favorite': isFavorite,
      },
    );
    return _beneficiaryFromJson(_dataMap(json));
  }

  @override
  Future<BeneficiaryModel> updateBeneficiary({
    required String id,
    required String fullName,
    required String phone,
    required CountryModel country,
    required OperatorModel operator,
    required bool isFavorite,
  }) async {
    final json = await _client.putJson(
      '/beneficiaries/$id',
      data: {
        'full_name': fullName,
        'phone': phone,
        'country_code': country.code,
        'operator_code': operator.id,
        'is_favorite': isFavorite,
      },
    );
    return _beneficiaryFromJson(_dataMap(json));
  }

  @override
  Future<void> deleteBeneficiary(String id) async {
    await _client.deleteJson('/beneficiaries/$id');
  }

  @override
  Future<BeneficiaryModel> toggleBeneficiaryFavorite(String id) async {
    final json = await _client.postJson('/beneficiaries/$id/favorite');
    return _beneficiaryFromJson(_dataMap(json));
  }

  @override
  Future<FeeQuoteModel> calculateFee({
    required double amount,
    required CountryModel sourceCountry,
    required CountryModel destinationCountry,
  }) async {
    final json = await _client.postJson(
      '/transfer/calculate',
      data: {
        'amount': amount,
        'source_country': sourceCountry.code,
        'destination_country': destinationCountry.code,
      },
    );
    return _quoteFromJson(_dataMap(json));
  }

  @override
  Future<ReceiptModel> submitTransfer({
    required BeneficiaryModel beneficiary,
    required CountryModel sourceCountry,
    required FeeQuoteModel quote,
  }) async {
    final json = await _client.postJson(
      '/transfer/send',
      data: {
        'beneficiary_id': beneficiary.id,
        'amount': quote.amount,
        'source_country': sourceCountry.code,
      },
    );
    return _receiptFromJson(_dataMap(json), beneficiary, sourceCountry);
  }

  static List<Map<String, dynamic>> _dataList(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List) {
      return data
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }
    return const [];
  }

  static Map<String, dynamic> _dataMap(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return json;
  }

  static CountryModel _countryFromJson(Map<String, dynamic> json) {
    return CountryModel(
      code: _string(json['code']),
      name: _string(json['name']),
      flag: _string(json['flag_emoji']),
      currency: _string(json['currency_code']),
      phoneCode: _string(json['phone_code']),
    );
  }

  static OperatorModel _operatorFromJson(
    Map<String, dynamic> json,
    String fallbackCountryCode,
  ) {
    return OperatorModel(
      id: _string(json['code'], fallback: _string(json['id'])),
      name: _string(json['name']),
      countryCode: _string(json['country_code'], fallback: fallbackCountryCode),
      serviceCode: _string(json['service_code']),
    );
  }

  static BeneficiaryModel _beneficiaryFromJson(Map<String, dynamic> json) {
    final country = CountryModel(
      code: _string(json['country_code']),
      name: _string(json['country_name']),
      flag: _string(json['flag_emoji']),
      currency: _string(json['currency_code']),
      phoneCode: _phoneCodeFromPhone(_string(json['phone'])),
    );
    final operator = OperatorModel(
      id: _string(json['operator_code']),
      name: _string(json['operator_name']),
      countryCode: country.code,
      serviceCode: _string(json['service_code']),
    );

    return BeneficiaryModel(
      id: _string(json['id']),
      fullName: _string(json['full_name']),
      phone: _string(json['phone']),
      country: country,
      operator: operator,
      isFavorite: json['is_favorite'] == true,
      initials: _initials(_string(json['full_name'])),
    );
  }

  static FeeQuoteModel _quoteFromJson(Map<String, dynamic> json) {
    return FeeQuoteModel(
      amount: _double(json['amount']),
      fee: _double(json['fee']),
      exchangeRate: _double(json['exchange_rate']),
      receivedAmount: _double(json['received_amount']),
      sourceCurrency: _string(json['source_currency']),
      destinationCurrency: _string(json['destination_currency']),
    );
  }

  static ReceiptModel _receiptFromJson(
    Map<String, dynamic> json,
    BeneficiaryModel beneficiary,
    CountryModel sourceCountry,
  ) {
    return ReceiptModel(
      reference: _string(json['reference']),
      senderName: 'Jean Dupont',
      receiverName: _string(
        json['beneficiary_name'],
        fallback: beneficiary.fullName,
      ),
      corridor:
          '${_string(json['origin_code'], fallback: sourceCountry.code)} -> ${_string(json['destination_code'], fallback: beneficiary.country.code)}',
      operatorName: _string(
        json['operator_name'],
        fallback: beneficiary.operator.name,
      ),
      amount: _double(json['amount']),
      fee: _double(json['fee']),
      receivedAmount: _double(json['received_amount']),
      currency: _string(json['currency'], fallback: sourceCountry.currency),
      createdAt:
          DateTime.tryParse(_string(json['created_at'])) ?? DateTime.now(),
    );
  }

  static String _string(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString();
    return text.isEmpty ? fallback : text;
  }

  static double _double(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _initials(String fullName) {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((part) => part[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }

  static String _phoneCodeFromPhone(String phone) {
    final match = RegExp(r'^\+\d+').firstMatch(phone.replaceAll(' ', ''));
    return match?.group(0) ?? '';
  }
}
