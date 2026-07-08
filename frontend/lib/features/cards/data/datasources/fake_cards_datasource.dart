import '../models/card_transaction_model.dart';
import '../models/virtual_card_model.dart';

class FakeCardsDatasource {
  final List<VirtualCardModel> _cards = [
    const VirtualCardModel(
      id: 'card_1',
      holderName: 'Jean Dupont',
      lastDigits: '4568',
      currency: 'XOF',
      balance: 250000,
      expiry: '09/29',
      isFrozen: false,
      dailyLimit: 100000,
      monthlyLimit: 1000000,
      onlinePaymentsEnabled: true,
      label: 'Carte principale',
    ),
    const VirtualCardModel(
      id: 'card_2',
      holderName: 'Jean Dupont',
      lastDigits: '9821',
      currency: 'XAF',
      balance: 145000,
      expiry: '11/28',
      isFrozen: true,
      dailyLimit: 75000,
      monthlyLimit: 750000,
      onlinePaymentsEnabled: false,
      label: 'Voyage Afrique centrale',
    ),
  ];

  final List<CardTransactionModel> _transactions = [
    CardTransactionModel(
      id: 'ct_1',
      cardId: 'card_1',
      merchant: 'Recharge MTN',
      subtitle: 'Crédit carte • Aujourd’hui',
      amount: 50000,
      currency: 'XOF',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isCredit: true,
      status: 'completed',
    ),
    CardTransactionModel(
      id: 'ct_2',
      cardId: 'card_1',
      merchant: 'Netflix',
      subtitle: 'Paiement en ligne • Hier',
      amount: 7000,
      currency: 'XOF',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isCredit: false,
      status: 'completed',
    ),
    CardTransactionModel(
      id: 'ct_3',
      cardId: 'card_1',
      merchant: 'Google Play',
      subtitle: 'Paiement en ligne • Cette semaine',
      amount: 3000,
      currency: 'XOF',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isCredit: false,
      status: 'completed',
    ),
    CardTransactionModel(
      id: 'ct_4',
      cardId: 'card_2',
      merchant: 'Recharge Airtel',
      subtitle: 'Crédit carte • Cette semaine',
      amount: 75000,
      currency: 'XAF',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isCredit: true,
      status: 'completed',
    ),
  ];

  Future<List<VirtualCardModel>> getCards() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_cards);
  }

  Future<VirtualCardModel?> getCardById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    for (final card in _cards) {
      if (card.id == id) return card;
    }
    return null;
  }

  Future<List<CardTransactionModel>> getTransactions(String cardId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _transactions.where((item) => item.cardId == cardId).toList();
  }

  Future<VirtualCardModel> createCard({required String currency, required double dailyLimit}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final card = VirtualCardModel(
      id: 'card_${_cards.length + 1}',
      holderName: 'Jean Dupont',
      lastDigits: '${7000 + _cards.length * 137}',
      currency: currency,
      balance: 0,
      expiry: '12/29',
      isFrozen: false,
      dailyLimit: dailyLimit,
      monthlyLimit: dailyLimit * 10,
      onlinePaymentsEnabled: true,
      label: 'Nouvelle carte',
    );
    _cards.add(card);
    return card;
  }

  Future<VirtualCardModel> topUp(String cardId, double amount) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _cards.indexWhere((card) => card.id == cardId);
    final updated = _cards[index].copyWith(balance: _cards[index].balance + amount);
    _cards[index] = updated;
    _transactions.insert(
      0,
      CardTransactionModel(
        id: 'ct_${_transactions.length + 1}',
        cardId: cardId,
        merchant: 'Recharge Mobile Money',
        subtitle: 'Crédit carte • Maintenant',
        amount: amount,
        currency: updated.currency,
        createdAt: DateTime.now(),
        isCredit: true,
        status: 'completed',
      ),
    );
    return updated;
  }

  Future<VirtualCardModel> toggleFreeze(String cardId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _cards.indexWhere((card) => card.id == cardId);
    final updated = _cards[index].copyWith(isFrozen: !_cards[index].isFrozen);
    _cards[index] = updated;
    return updated;
  }
}
