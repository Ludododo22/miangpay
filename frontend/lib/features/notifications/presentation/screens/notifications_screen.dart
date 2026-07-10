import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/notification_message_model.dart';
import '../providers/notifications_providers.dart';
import '../widgets/notification_message_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  NotificationCategory selectedCategory = NotificationCategory.all;

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Centre de messages'),
        actions: [
          IconButton(
            tooltip: 'Tout marquer lu',
            onPressed: _markAllRead,
            icon: const Icon(Icons.mark_email_read_rounded),
          ),
          IconButton(
            onPressed: () => context.go('/notifications/messages'),
            icon: const Icon(Icons.mark_chat_unread_rounded),
          ),
          IconButton(
            onPressed: () => context.go('/notifications/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Erreur',
          message: 'Impossible de charger les notifications.',
        ),
        data: (items) {
          final filtered = selectedCategory == NotificationCategory.all
              ? items
              : items.where((e) => e.category == selectedCategory).toList();
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _HeaderCard(unreadCount: items.where((e) => !e.isRead).length),
              const SizedBox(height: 20),
              _CategoryChips(
                selected: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value),
              ),
              const SizedBox(height: 20),
              if (filtered.isEmpty)
                const AppEmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: 'Aucune notification',
                  message: 'Vous etes a jour.',
                )
              else
                ...filtered.map(
                  (item) => NotificationMessageCard(
                    notification: item,
                    onMarkRead: () => _markRead(item.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _markRead(String id) async {
    await ref.read(notificationsRepositoryProvider).markRead(id);
    _refreshNotifications();
  }

  Future<void> _markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    _refreshNotifications();
  }

  void _refreshNotifications() {
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationsProvider);
    ref.invalidate(messageThreadsProvider);
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vos alertes MiangPay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$unreadCount notification(s) non lue(s)',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.selected,
    required this.onChanged,
  });

  final NotificationCategory selected;
  final ValueChanged<NotificationCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = <NotificationCategory, String>{
      NotificationCategory.all: 'Toutes',
      NotificationCategory.transaction: 'Transactions',
      NotificationCategory.security: 'Securite',
      NotificationCategory.promotion: 'Promos',
      NotificationCategory.loyalty: 'Fidelite',
      NotificationCategory.card: 'Cartes',
      NotificationCategory.support: 'Support',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: values.entries.map((entry) {
          final isSelected = selected == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              selectedColor: AppColors.secondary.withValues(alpha: .18),
              onSelected: (_) => onChanged(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}
