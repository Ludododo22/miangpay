import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/promotion_providers.dart';

class PromotionDetailScreen extends ConsumerWidget {
  final String promotionId;
  const PromotionDetailScreen({super.key, required this.promotionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotions = ref.watch(promotionsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Détail promotion')),
      body: promotions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur: $error')),
        data: (items) {
          final promo = items.firstWhere((p) => p.id == promotionId, orElse: () => items.first);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(28)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(promo.tag, style: const TextStyle(color: AppColors.accent, fontSize: 42, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  Text(promo.title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(promo.description, style: const TextStyle(color: Colors.white70, height: 1.5)),
                ]),
              ),
              const SizedBox(height: 20),
              _InfoRow(label: 'Corridor', value: promo.corridor),
              _InfoRow(label: 'Catégorie', value: promo.category),
              _InfoRow(label: 'Expiration', value: promo.expiresAt),
              _InfoRow(label: 'Utilisations restantes', value: '${promo.remainingUses}'),
              const SizedBox(height: 24),
              const Text('Conditions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('Offre valable dans la limite des utilisations disponibles. La meilleure promotion applicable est automatiquement proposée avant confirmation du transfert.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 26),
              PrimaryButton(label: 'Profiter de cette offre', onPressed: () => Navigator.pop(context)),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ]),
    );
  }
}
