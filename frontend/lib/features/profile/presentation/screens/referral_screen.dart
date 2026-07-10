import 'package:flutter/material.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Parrainage')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(26)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.card_giftcard_rounded,
                      color: AppColors.accent, size: 40),
                  SizedBox(height: 14),
                  Text('Invitez vos proches',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900)),
                  SizedBox(height: 8),
                  Text(
                      'Gagnez 500 points pour chaque ami vérifié qui effectue son premier transfert.',
                      style: TextStyle(color: Colors.white70, height: 1.5)),
                ]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20)),
            child: Row(children: const [
              Expanded(
                  child: Text('JEAN2026',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2))),
              Icon(Icons.copy_rounded, color: AppColors.secondary)
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: const [
            Expanded(child: _ReferralStat(label: 'Invitations', value: '15')),
            SizedBox(width: 12),
            Expanded(child: _ReferralStat(label: 'Validées', value: '8')),
            SizedBox(width: 12),
            Expanded(child: _ReferralStat(label: 'Points', value: '4 000')),
          ]),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Partager mon code',
            icon: Icons.share_rounded,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Code de parrainage prêt à partager'))),
          ),
        ],
      ),
    );
  }
}

class _ReferralStat extends StatelessWidget {
  final String label;
  final String value;
  const _ReferralStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary))
        ]));
  }
}
