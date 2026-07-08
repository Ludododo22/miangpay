import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class KycIntroScreen extends StatelessWidget {
  const KycIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Vérification KYC')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)),
                child: const Icon(Icons.badge_rounded, color: AppColors.secondary, size: 48),
              ),
              const SizedBox(height: 28),
              const Text(
                'Sécurisez votre compte',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'La vérification d’identité permet d’augmenter vos limites, protéger vos transferts et respecter les obligations de conformité.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 28),
              const _KycRequirement(icon: Icons.person_rounded, title: 'Informations personnelles', subtitle: 'Nom, date de naissance et nationalité'),
              const _KycRequirement(icon: Icons.home_rounded, title: 'Adresse', subtitle: 'Pays, ville et quartier'),
              const _KycRequirement(icon: Icons.credit_card_rounded, title: 'Pièce d’identité', subtitle: 'CNI, passeport ou permis'),
              const _KycRequirement(icon: Icons.camera_alt_rounded, title: 'Selfie', subtitle: 'Photo de vérification rapide'),
              const Spacer(),
              PrimaryButton(label: 'Commencer la vérification', onPressed: () => context.go('/kyc-personal-info')),
            ],
          ),
        ),
      ),
    );
  }
}

class _KycRequirement extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _KycRequirement({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
