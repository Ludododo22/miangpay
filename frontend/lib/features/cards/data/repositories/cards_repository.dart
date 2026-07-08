import '../datasources/fake_cards_datasource.dart';
import '../models/card_transaction_model.dart';
import '../models/virtual_card_model.dart';

class CardsRepository {
  final FakeCardsDatasource datasource;

  const CardsRepository(this.datasource);

  Future<List<VirtualCardModel>> getCards() => datasource.getCards();
  Future<VirtualCardModel?> getCardById(String id) => datasource.getCardById(id);
  Future<List<CardTransactionModel>> getTransactions(String cardId) => datasource.getTransactions(cardId);
  Future<VirtualCardModel> createCard({required String currency, required double dailyLimit}) {
    return datasource.createCard(currency: currency, dailyLimit: dailyLimit);
  }
  Future<VirtualCardModel> topUp(String cardId, double amount) => datasource.topUp(cardId, amount);
  Future<VirtualCardModel> toggleFreeze(String cardId) => datasource.toggleFreeze(cardId);
}
