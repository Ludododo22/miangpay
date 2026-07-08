import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/notifications_providers.dart';
import '../widgets/message_thread_card.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadsAsync = ref.watch(messageThreadsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Messages')),
      body: threadsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(icon: Icons.error_outline_rounded, title: 'Erreur', message: 'Impossible de charger les messages.'),
        data: (threads) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22)),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppColors.secondary),
                  SizedBox(width: 12),
                  Expanded(child: Text('Assistant financier : vous êtes à 75% du niveau Platine.', style: TextStyle(fontWeight: FontWeight.w700))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...threads.map((thread) => MessageThreadCard(thread: thread)),
          ],
        ),
      ),
    );
  }
}
