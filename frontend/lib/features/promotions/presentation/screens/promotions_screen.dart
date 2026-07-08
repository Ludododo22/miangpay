import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/promotion_providers.dart';
import '../widgets/promotion_offer_card.dart';

class PromotionsScreen extends ConsumerWidget {
  const PromotionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promotions = ref.watch(promotionsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Promotions'),
        actions: [
          IconButton(onPressed: () => context.push('/promotions/coupons'), icon: const Icon(Icons.confirmation_number_rounded)),
        ],
      ),
      body: promotions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur: $error')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Offres du moment', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Des réductions adaptées à vos pays, vos habitudes et votre niveau de fidélité.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _CategoryChip(label: 'Toutes', selected: true),
                _CategoryChip(label: 'Corridors'),
                _CategoryChip(label: 'Fidélité'),
                _CategoryChip(label: 'Cartes'),
              ],
            ),
            const SizedBox(height: 20),
            for (final promotion in items) ...[
              PromotionOfferCard(
                promotion: promotion,
                onTap: () => context.push('/promotions/detail/${promotion.id}'),
              ),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _MiniAction(title: 'Mes coupons', icon: Icons.confirmation_number_rounded, onTap: () => context.push('/promotions/coupons'))),
                const SizedBox(width: 12),
                Expanded(child: _MiniAction(title: 'Campagnes', icon: Icons.campaign_rounded, onTap: () => context.push('/promotions/campaigns'))),
              ],
            ),
            const SizedBox(height: 12),
            _SavingsCard(onTap: () => context.push('/promotions/savings')),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.secondary : AppColors.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w700)),
    );
  }
}

class _MiniAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _MiniAction({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }
}

class _SavingsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _SavingsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(22)),
        child: const Row(children: [
          Icon(Icons.savings_rounded, color: AppColors.accent),
          SizedBox(width: 14),
          Expanded(child: Text('Vous avez économisé 42 350 XOF avec MiangPay', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
          Icon(Icons.chevron_right_rounded, color: Colors.white),
        ]),
      ),
    );
  }
}
