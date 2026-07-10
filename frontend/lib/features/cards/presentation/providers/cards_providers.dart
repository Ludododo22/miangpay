import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/fake_cards_datasource.dart';
import '../../data/models/card_transaction_model.dart';
import '../../data/models/virtual_card_model.dart';
import '../../data/repositories/cards_repository.dart';

final fakeCardsDatasourceProvider =
    Provider<FakeCardsDatasource>((ref) => FakeCardsDatasource());

final cardsRepositoryProvider = Provider<CardsRepository>((ref) {
  if (ref.watch(dataSourceModeProvider) == DataSourceMode.api) {
    return CardsRepository.api(ref.watch(apiClientProvider));
  }
  return CardsRepository(ref.watch(fakeCardsDatasourceProvider));
});

final cardsProvider = FutureProvider<List<VirtualCardModel>>((ref) async {
  return ref.watch(cardsRepositoryProvider).getCards();
});

final selectedCardProvider =
    FutureProvider.family<VirtualCardModel?, String>((ref, id) async {
  return ref.watch(cardsRepositoryProvider).getCardById(id);
});

final cardTransactionsProvider =
    FutureProvider.family<List<CardTransactionModel>, String>(
        (ref, cardId) async {
  return ref.watch(cardsRepositoryProvider).getTransactions(cardId);
});
