import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/steps/progress_stepper.dart';
import '../../../../core/forms/form_validators.dart';
import '../../../../core/theme/app_colors.dart';

class KycAddressScreen extends StatefulWidget {
  const KycAddressScreen({super.key});

  @override
  State<KycAddressScreen> createState() => _KycAddressScreenState();
}

class _KycAddressScreenState extends State<KycAddressScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Adresse')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressStepper(currentStep: 1, totalSteps: 4),
                const SizedBox(height: 28),
                const Text('Adresse de résidence',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary)),
                const SizedBox(height: 16),
                AppTextField(
                    label: 'Pays',
                    prefixIcon: Icons.public_rounded,
                    validator: FormValidators.required),
                const SizedBox(height: 16),
                AppTextField(
                    label: 'Ville',
                    prefixIcon: Icons.location_city_rounded,
                    validator: FormValidators.required),
                const SizedBox(height: 16),
                AppTextField(
                    label: 'Quartier / Rue',
                    prefixIcon: Icons.home_rounded,
                    validator: FormValidators.required),
                const SizedBox(height: 16),
                AppTextField(
                    label: 'Adresse complète',
                    prefixIcon: Icons.place_rounded,
                    validator: FormValidators.required),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Continuer',
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      context.go('/kyc-document');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
