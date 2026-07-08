import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/promotion_providers.dart';
import '../widgets/coupon_card.dart';

class CouponsScreen extends ConsumerWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = ref.watch(couponsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mes coupons')),
      body: coupons.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur: $error')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Coupons disponibles', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            for (final coupon in items) ...[
              CouponCard(coupon: coupon),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
