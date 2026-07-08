import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/steps/progress_stepper.dart';
import '../../../../core/theme/app_colors.dart';

class KycPersonalInfoScreen extends StatelessWidget {
  const KycPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Identité')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressStepper(currentStep: 0, totalSteps: 4),
              const SizedBox(height: 28),
              const Text('Informations personnelles', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
              const SizedBox(height: 16),
              const AppTextField(label: 'Nom complet', prefixIcon: Icons.person_rounded),
              const SizedBox(height: 16),
              const AppTextField(label: 'Date de naissance', hint: 'JJ/MM/AAAA', prefixIcon: Icons.calendar_today_rounded),
              const SizedBox(height: 16),
              const AppTextField(label: 'Nationalité', prefixIcon: Icons.flag_rounded),
              const SizedBox(height: 16),
              const AppTextField(label: 'Profession', prefixIcon: Icons.work_rounded),
              const SizedBox(height: 32),
              PrimaryButton(label: 'Continuer', onPressed: () => context.go('/kyc-address')),
            ],
          ),
        ),
      ),
    );
  }
}
