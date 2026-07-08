import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/steps/progress_stepper.dart';
import '../../../../core/theme/app_colors.dart';

class KycSelfieScreen extends StatelessWidget {
  const KycSelfieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Selfie')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressStepper(currentStep: 3, totalSteps: 4),
              const SizedBox(height: 28),
              const Text('Vérification selfie', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
              const SizedBox(height: 10),
              const Text('Prenez une photo claire de votre visage. Retirez lunettes, masque et couvre-visage.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
              const SizedBox(height: 32),
              Center(
                child: Container(
                  height: 230,
                  width: 230,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 2),
                  ),
                  child: const Icon(Icons.face_rounded, size: 100, color: AppColors.secondary),
                ),
              ),
              const Spacer(),
              PrimaryButton(label: 'Prendre le selfie', icon: Icons.camera_alt_rounded, onPressed: () => context.go('/kyc-review')),
            ],
          ),
        ),
      ),
    );
  }
}
