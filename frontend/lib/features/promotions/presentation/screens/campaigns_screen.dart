import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/promotion_providers.dart';
import '../widgets/campaign_card.dart';

class CampaignsScreen extends ConsumerWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaigns = ref.watch(campaignsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Campagnes')),
      body: campaigns.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur: $error')),
        data: (items) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('Campagnes actives', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            for (final campaign in items) ...[
              CampaignCard(campaign: campaign),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}
