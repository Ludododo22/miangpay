import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_json.dart';
import '../datasources/fake_notifications_datasource.dart';
import '../models/message_thread_model.dart';
import '../models/notification_message_model.dart';
import '../models/notification_settings_model.dart';

class NotificationsRepository {
  final FakeNotificationsDatasource _datasource;
  final ApiClient? _client;
  final Set<String> _readIds = {};
  bool _allRead = false;

  NotificationsRepository(this._datasource) : _client = null;
  NotificationsRepository.api(ApiClient client)
      : _datasource = FakeNotificationsDatasource(),
        _client = client;

  Future<List<NotificationMessageModel>> getNotifications() async {
    final client = _client;
    if (client == null) {
      final items = await _datasource.getNotifications();
      return items
          .map(
            (item) => item.copyWith(
              isRead: _allRead || _readIds.contains(item.id) || item.isRead,
            ),
          )
          .toList();
    }

    final json = await client.getJson('/notifications');
    return ApiJson.dataList(json).map(_notificationFromJson).toList();
  }

  Future<List<MessageThreadModel>> getThreads() async {
    final client = _client;
    if (client == null) return _datasource.getThreads();

    final notifications = await getNotifications();
    return notifications.take(4).map((item) {
      return MessageThreadModel(
        id: item.id,
        title: item.title,
        lastMessage: item.body,
        type: item.category.name,
        updatedAt: item.createdAt,
        unreadCount: item.isRead ? 0 : 1,
      );
    }).toList();
  }

  Future<NotificationSettingsModel> getSettings() => _datasource.getSettings();

  Future<void> markRead(String id) async {
    final client = _client;
    if (client == null) {
      _readIds.add(id);
      return;
    }
    await client.postJson('/notifications/$id/read');
  }

  Future<void> markAllRead() async {
    final client = _client;
    if (client == null) {
      _allRead = true;
      return;
    }
    await client.postJson('/notifications/read-all');
  }

  NotificationMessageModel _notificationFromJson(Map<String, dynamic> json) {
    return NotificationMessageModel(
      id: ApiJson.string(json['id']),
      title: ApiJson.string(json['title']),
      body: ApiJson.string(json['body']),
      category: _category(ApiJson.string(json['category'])),
      priority: _priority(ApiJson.string(json['priority'])),
      createdAt: ApiJson.date(json['created_at']),
      isRead: ApiJson.boolean(json['is_read']),
      actionRoute: ApiJson.string(json['action_route']).isEmpty
          ? null
          : ApiJson.string(json['action_route']),
    );
  }

  NotificationCategory _category(String value) {
    return NotificationCategory.values.firstWhere(
      (item) => item.name == value,
      orElse: () => NotificationCategory.all,
    );
  }

  NotificationPriority _priority(String value) {
    return NotificationPriority.values.firstWhere(
      (item) => item.name == value,
      orElse: () => NotificationPriority.info,
    );
  }
}
