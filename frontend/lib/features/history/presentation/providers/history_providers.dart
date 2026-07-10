import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/fake_history_datasource.dart';
import '../../data/models/activity_transaction_model.dart';
import '../../data/repositories/history_api_repository.dart';

final historyDatasourceProvider = Provider<FakeHistoryDatasource>((ref) {
  return FakeHistoryDatasource();
});

final transactionsProvider =
    FutureProvider<List<ActivityTransactionModel>>((ref) {
  if (ref.watch(dataSourceModeProvider) == DataSourceMode.api) {
    return HistoryApiRepository(ref.watch(apiClientProvider)).getTransactions();
  }
  return ref.watch(historyDatasourceProvider).getTransactions();
});

final transactionByReferenceProvider =
    Provider.family<ActivityTransactionModel?, String>((ref, reference) {
  final transactions = ref.watch(transactionsProvider).valueOrNull ?? [];
  try {
    return transactions
        .firstWhere((transaction) => transaction.reference == reference);
  } catch (_) {
    return null;
  }
});
