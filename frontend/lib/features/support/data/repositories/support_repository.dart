import '../datasources/fake_support_datasource.dart';
import '../models/chat_message_model.dart';
import '../models/faq_item_model.dart';
import '../models/support_ticket_model.dart';

class SupportRepository {
  final FakeSupportDatasource _datasource;

  const SupportRepository(this._datasource);

  Future<List<FaqItemModel>> getFaqs() => _datasource.getFaqs();
  Future<List<SupportTicketModel>> getTickets() => _datasource.getTickets();
  Future<List<ChatMessageModel>> getChatMessages() => _datasource.getChatMessages();
}
