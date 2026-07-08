import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/steps/progress_stepper.dart';
import '../../../../core/theme/app_colors.dart';

class KycDocumentScreen extends StatelessWidget {
  const KycDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Document')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressStepper(currentStep: 2, totalSteps: 4),
              const SizedBox(height: 28),
              const Text('Pièce d’identité', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
              const SizedBox(height: 10),
              const Text('Ajoutez une photo nette du recto et du verso de votre document.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 24),
              const _UploadBox(title: 'Recto du document', icon: Icons.badge_rounded),
              const SizedBox(height: 16),
              const _UploadBox(title: 'Verso du document', icon: Icons.badge_outlined),
              const Spacer(),
              PrimaryButton(label: 'Continuer', onPressed: () => context.go('/kyc-selfie')),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final String title;
  final IconData icon;

  const _UploadBox({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: .25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondary, size: 38),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 6),
          const Text('Appuyer pour téléverser', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
