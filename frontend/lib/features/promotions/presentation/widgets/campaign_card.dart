import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/campaign_model.dart';

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  const CampaignCard({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.campaign_rounded, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(child: Text(campaign.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900))),
          Text(campaign.timeLeft, style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        Text(campaign.description, style: const TextStyle(color: AppColors.textSecondary, height: 1.45)),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: campaign.progress / 100,
            minHeight: 10,
            backgroundColor: AppColors.background,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Text('${campaign.progress}% complété', style: const TextStyle(fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(campaign.reward, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900)),
        ]),
      ]),
    );
  }
}
