import '../datasources/fake_notifications_datasource.dart';
import '../models/message_thread_model.dart';
import '../models/notification_message_model.dart';
import '../models/notification_settings_model.dart';

class NotificationsRepository {
  final FakeNotificationsDatasource _datasource;

  const NotificationsRepository(this._datasource);

  Future<List<NotificationMessageModel>> getNotifications() => _datasource.getNotifications();
  Future<List<MessageThreadModel>> getThreads() => _datasource.getThreads();
  Future<NotificationSettingsModel> getSettings() => _datasource.getSettings();
}
