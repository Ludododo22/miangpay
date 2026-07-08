import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';

class LoyaltyHistoryScreen extends ConsumerWidget {
  const LoyaltyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(loyaltyActivitiesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Historique des points')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: activities.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = activities[index];
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.add_circle_rounded, color: AppColors.secondary),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${item.source} • ${DateFormat('dd/MM/yyyy').format(item.date)}', style: const TextStyle(color: AppColors.textSecondary)),
              ])),
              Text('+${item.points}', style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
            ]),
          );
        },
      ),
    );
  }
}
