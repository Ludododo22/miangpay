import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/support_providers.dart';

class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqs = ref.watch(faqItemsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('FAQ')),
      body: faqs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Impossible de charger la FAQ')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Questions fréquentes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
            const SizedBox(height: 16),
            ...items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    title: Text(item.question, style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(item.category, style: const TextStyle(color: AppColors.textSecondary)),
                    children: [Text(item.answer, style: const TextStyle(height: 1.5, color: AppColors.textSecondary))],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
