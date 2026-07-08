import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_providers.dart';

class SecurityLogScreen extends ConsumerWidget {
  const SecurityLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(securityLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Journal de sécurité')),
      body: logs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Container(height: 44, width: 44, decoration: BoxDecoration(color: AppColors.info.withValues(alpha: .1), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.shield_rounded, color: AppColors.info)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(item.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(item.date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ])),
              ]),
            );
          },
        ),
      ),
    );
  }
}
