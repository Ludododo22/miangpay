import '../models/message_thread_model.dart';
import '../models/notification_message_model.dart';
import '../models/notification_settings_model.dart';

class FakeNotificationsDatasource {
  Future<List<NotificationMessageModel>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();
    return [
      NotificationMessageModel(
        id: 'n1',
        title: 'Transfert réussi',
        body: 'Ahmed Diallo a reçu 48 750 XOF au Bénin via MTN.',
        category: NotificationCategory.transaction,
        priority: NotificationPriority.important,
        createdAt: now.subtract(const Duration(minutes: 8)),
        actionLabel: 'Voir le reçu',
        actionRoute: '/history/receipt/TXN-20260707-001',
      ),
      NotificationMessageModel(
        id: 'n2',
        title: 'Nouvelle connexion détectée',
        body: 'Connexion depuis Chrome à Cotonou. Vérifiez si c’était bien vous.',
        category: NotificationCategory.security,
        priority: NotificationPriority.critical,
        createdAt: now.subtract(const Duration(hours: 1)),
        actionLabel: 'Sécuriser',
        actionRoute: '/profile/security',
      ),
      NotificationMessageModel(
        id: 'n3',
        title: 'Promotion vers le Sénégal',
        body: '-30% sur les frais jusqu’à ce soir pour les transferts vers le Sénégal.',
        category: NotificationCategory.promotion,
        priority: NotificationPriority.marketing,
        createdAt: now.subtract(const Duration(hours: 3)),
        actionLabel: 'Profiter',
        actionRoute: '/promotions',
      ),
      NotificationMessageModel(
        id: 'n4',
        title: 'Vous gagnez 120 points',
        body: 'Votre dernier transfert vous rapporte des points fidélité MiangPay.',
        category: NotificationCategory.loyalty,
        priority: NotificationPriority.info,
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: true,
        actionLabel: 'Voir mes points',
        actionRoute: '/loyalty',
      ),
      NotificationMessageModel(
        id: 'n5',
        title: 'Carte virtuelle rechargée',
        body: 'Votre carte XOF a été rechargée de 50 000 XOF.',
        category: NotificationCategory.card,
        priority: NotificationPriority.important,
        createdAt: now.subtract(const Duration(days: 1)),
        actionLabel: 'Voir la carte',
        actionRoute: '/cards',
      ),
      NotificationMessageModel(
        id: 'n6',
        title: 'Réponse du support',
        body: 'Votre ticket #4521 a reçu une réponse de l’équipe support.',
        category: NotificationCategory.support,
        priority: NotificationPriority.important,
        createdAt: now.subtract(const Duration(days: 2)),
        actionLabel: 'Ouvrir',
        actionRoute: '/support',
      ),
    ];
  }

  Future<List<MessageThreadModel>> getThreads() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return [
      MessageThreadModel(id: 't1', title: 'Support MiangPay', lastMessage: 'Nous avons vérifié votre transfert.', type: 'Support', updatedAt: now.subtract(const Duration(minutes: 24)), unreadCount: 1),
      MessageThreadModel(id: 't2', title: 'Alertes sécurité', lastMessage: 'Nouvelle connexion sécurisée.', type: 'Sécurité', updatedAt: now.subtract(const Duration(hours: 1))),
      MessageThreadModel(id: 't3', title: 'Campagnes', lastMessage: 'Semaine diaspora : points doublés.', type: 'Marketing', updatedAt: now.subtract(const Duration(days: 1))),
      MessageThreadModel(id: 't4', title: 'Système', lastMessage: 'Votre KYC est validé.', type: 'Système', updatedAt: now.subtract(const Duration(days: 3))),
    ];
  }

  Future<NotificationSettingsModel> getSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return const NotificationSettingsModel();
  }
}
