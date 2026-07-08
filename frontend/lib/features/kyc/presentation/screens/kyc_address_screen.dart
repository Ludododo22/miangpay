import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/steps/progress_stepper.dart';
import '../../../../core/theme/app_colors.dart';

class KycAddressScreen extends StatelessWidget {
  const KycAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Adresse')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressStepper(currentStep: 1, totalSteps: 4),
              const SizedBox(height: 28),
              const Text('Adresse de résidence', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
              const SizedBox(height: 16),
              const AppTextField(label: 'Pays', prefixIcon: Icons.public_rounded),
              const SizedBox(height: 16),
              const AppTextField(label: 'Ville', prefixIcon: Icons.location_city_rounded),
              const SizedBox(height: 16),
              const AppTextField(label: 'Quartier / Rue', prefixIcon: Icons.home_rounded),
              const SizedBox(height: 16),
              const AppTextField(label: 'Adresse complète', prefixIcon: Icons.place_rounded),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Continuer', onPressed: () => context.go('/kyc-document')),
            ],
          ),
        ),
      ),
    );
  }
}
