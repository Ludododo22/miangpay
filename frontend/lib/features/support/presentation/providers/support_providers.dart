import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/fake_support_datasource.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/faq_item_model.dart';
import '../../data/models/support_ticket_model.dart';
import '../../data/repositories/support_repository.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  if (ref.watch(dataSourceModeProvider) == DataSourceMode.api) {
    return SupportRepository.api(ref.watch(apiClientProvider));
  }
  return SupportRepository(FakeSupportDatasource());
});

final faqItemsProvider = FutureProvider<List<FaqItemModel>>((ref) {
  return ref.watch(supportRepositoryProvider).getFaqs();
});

final supportTicketsProvider = FutureProvider<List<SupportTicketModel>>((ref) {
  return ref.watch(supportRepositoryProvider).getTickets();
});

final supportChatProvider = FutureProvider<List<ChatMessageModel>>((ref) {
  return ref.watch(supportRepositoryProvider).getChatMessages();
});
