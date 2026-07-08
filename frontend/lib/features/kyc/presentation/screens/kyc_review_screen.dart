import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class KycReviewScreen extends StatelessWidget {
  const KycReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Résumé KYC')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const _ReviewTile(icon: Icons.person_rounded, title: 'Identité', status: 'Complété'),
              const _ReviewTile(icon: Icons.home_rounded, title: 'Adresse', status: 'Complété'),
              const _ReviewTile(icon: Icons.badge_rounded, title: 'Document', status: 'Ajouté'),
              const _ReviewTile(icon: Icons.face_rounded, title: 'Selfie', status: 'Ajouté'),
              const Spacer(),
              PrimaryButton(label: 'Soumettre la vérification', onPressed: () => context.go('/kyc-pending')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;

  const _ReviewTile({required this.icon, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary))),
          Text(status, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
