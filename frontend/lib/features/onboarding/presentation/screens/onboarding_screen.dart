import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.public_rounded, size: 120, color: AppColors.secondary),
              const SizedBox(height: 32),
              const Text(
                'Envoyez de l’argent partout en Afrique',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'Avec MiangPay, transférez rapidement, simplement et en toute sécurité vers plusieurs pays africains.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
              ),
              const Spacer(),
              PrimaryButton(label: 'Commencer', onPressed: () => context.go('/country-selection')),
            ],
          ),
        ),
      ),
    );
  }
}
