import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_providers.dart';
import '../../data/datasources/fake_notifications_datasource.dart';
import '../../data/models/message_thread_model.dart';
import '../../data/models/notification_message_model.dart';
import '../../data/models/notification_settings_model.dart';
import '../../data/repositories/notifications_repository.dart';

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  if (ref.watch(dataSourceModeProvider) == DataSourceMode.api) {
    return NotificationsRepository.api(ref.watch(apiClientProvider));
  }
  return NotificationsRepository(FakeNotificationsDatasource());
});

final notificationsProvider =
    FutureProvider<List<NotificationMessageModel>>((ref) {
  return ref.watch(notificationsRepositoryProvider).getNotifications();
});

final unreadNotificationsProvider = FutureProvider<int>((ref) async {
  final items = await ref.watch(notificationsProvider.future);
  return items.where((item) => !item.isRead).length;
});

final messageThreadsProvider = FutureProvider<List<MessageThreadModel>>((ref) {
  return ref.watch(notificationsRepositoryProvider).getThreads();
});

final notificationSettingsProvider =
    FutureProvider<NotificationSettingsModel>((ref) {
  return ref.watch(notificationsRepositoryProvider).getSettings();
});
