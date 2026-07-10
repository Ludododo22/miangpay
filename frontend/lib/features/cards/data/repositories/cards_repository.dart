import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../datasources/fake_cards_datasource.dart';
import '../models/card_transaction_model.dart';
import '../models/virtual_card_model.dart';

class CardsRepository {
  final FakeCardsDatasource? datasource;
  final ApiClient? _client;

  const CardsRepository(this.datasource) : _client = null;
  const CardsRepository.api(ApiClient client)
      : datasource = null,
        _client = client;

  Future<List<VirtualCardModel>> getCards() async {
    final client = _client;
    if (client == null) return datasource!.getCards();

    final json = await client.getJson('/cards');
    return ApiJson.dataList(json).map(_cardFromJson).toList();
  }

  Future<VirtualCardModel?> getCardById(String id) async {
    final client = _client;
    if (client == null) return datasource!.getCardById(id);

    final json = await client.getJson('/cards/$id');
    return _cardFromJson(ApiJson.dataMap(json));
  }

  Future<List<CardTransactionModel>> getTransactions(String cardId) async {
    final client = _client;
    if (client == null) return datasource!.getTransactions(cardId);

    final json = await client.getJson('/cards/$cardId');
    return ApiJson.list(json, 'transactions')
        .map((item) => _transactionFromJson(item, cardId))
        .toList();
  }

  Future<VirtualCardModel> createCard({
    required String currency,
    required double dailyLimit,
  }) async {
    final client = _client;
    if (client == null) {
      return datasource!.createCard(currency: currency, dailyLimit: dailyLimit);
    }

    final json = await client.postJson(
      '/cards',
      data: {
        'currency': currency,
        'daily_limit': dailyLimit,
      },
    );
    return _cardFromJson(ApiJson.dataMap(json));
  }

  Future<VirtualCardModel> topUp(String cardId, double amount) async {
    final client = _client;
    if (client == null) return datasource!.topUp(cardId, amount);

    final json = await client.postJson(
      '/cards/$cardId/load',
      data: {'amount': amount},
    );
    return _cardFromJson(ApiJson.dataMap(json));
  }

  Future<VirtualCardModel> toggleFreeze(String cardId) async {
    final client = _client;
    if (client == null) return datasource!.toggleFreeze(cardId);

    final current = await getCardById(cardId);
    final path = current?.isFrozen == true ? 'unblock' : 'block';
    final json = await client.postJson('/cards/$cardId/$path');
    return _cardFromJson(ApiJson.dataMap(json));
  }

  VirtualCardModel _cardFromJson(Map<String, dynamic> json) {
    final month =
        ApiJson.integer(json['expiry_month']).toString().padLeft(2, '0');
    final year = ApiJson.integer(json['expiry_year']).toString();
    return VirtualCardModel(
      id: ApiJson.string(json['id']),
      holderName:
          ApiJson.string(json['holder_name'], fallback: 'MiangPay User'),
      lastDigits: ApiJson.string(json['last_digits'], fallback: '0000'),
      currency: ApiJson.string(json['currency'], fallback: 'XOF'),
      balance: ApiJson.decimal(json['balance']),
      expiry:
          '$month/${year.length >= 2 ? year.substring(year.length - 2) : year}',
      isFrozen: ApiJson.boolean(json['is_frozen']),
      dailyLimit: ApiJson.decimal(json['daily_limit']),
      monthlyLimit: ApiJson.decimal(json['monthly_limit']),
      onlinePaymentsEnabled:
          ApiJson.boolean(json['online_payments_enabled'], fallback: true),
      label: ApiJson.string(json['label'], fallback: 'Carte MiangPay'),
    );
  }

  CardTransactionModel _transactionFromJson(
    Map<String, dynamic> json,
    String cardId,
  ) {
    return CardTransactionModel(
      id: ApiJson.string(json['id']),
      cardId: ApiJson.string(json['virtual_card_id'], fallback: cardId),
      merchant: ApiJson.string(json['merchant']),
      subtitle: ApiJson.string(json['subtitle']),
      amount: ApiJson.decimal(json['amount']),
      currency: ApiJson.string(json['currency'], fallback: 'XOF'),
      createdAt: ApiJson.date(json['created_at']),
      isCredit: ApiJson.boolean(json['is_credit']),
      status: ApiJson.string(json['status'], fallback: 'completed'),
    );
  }
}
