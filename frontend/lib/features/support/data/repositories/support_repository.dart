import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../datasources/fake_support_datasource.dart';
import '../models/chat_message_model.dart';
import '../models/faq_item_model.dart';
import '../models/support_ticket_model.dart';

class SupportRepository {
  final FakeSupportDatasource _datasource;
  final ApiClient? _client;

  const SupportRepository(this._datasource) : _client = null;
  SupportRepository.api(ApiClient client)
      : _datasource = FakeSupportDatasource(),
        _client = client;

  Future<List<FaqItemModel>> getFaqs() => _datasource.getFaqs();

  Future<List<SupportTicketModel>> getTickets() async {
    final client = _client;
    if (client == null) return _datasource.getTickets();

    final json = await client.getJson('/support/tickets');
    return ApiJson.dataList(json).map(_ticketFromJson).toList();
  }

  Future<List<ChatMessageModel>> getChatMessages() =>
      _datasource.getChatMessages();

  SupportTicketModel _ticketFromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: ApiJson.string(json['reference'],
          fallback: ApiJson.string(json['id'])),
      subject: ApiJson.string(json['subject']),
      category: ApiJson.string(json['category']),
      status: ApiJson.string(json['status']),
      lastMessage: ApiJson.string(json['priority'], fallback: 'Ticket ouvert'),
      createdAt: ApiJson.date(json['created_at']),
    );
  }
}
