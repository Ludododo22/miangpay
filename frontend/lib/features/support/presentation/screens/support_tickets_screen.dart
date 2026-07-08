import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/support_providers.dart';
import '../widgets/support_ticket_tile.dart';

class SupportTicketsScreen extends ConsumerWidget {
  const SupportTicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(supportTicketsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mes tickets')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PrimaryButton(label: 'Créer un ticket', icon: Icons.add_rounded, onPressed: () => context.push('/support/new-ticket')),
          const SizedBox(height: 20),
          tickets.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Impossible de charger les tickets'),
            data: (items) => Column(children: items.map((ticket) => SupportTicketTile(ticket: ticket)).toList()),
          ),
        ],
      ),
    );
  }
}
