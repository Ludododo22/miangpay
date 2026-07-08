import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mot de passe oublié')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Réinitialisation',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Entrez votre numéro. Nous vous enverrons un code de vérification.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              PhoneField(controller: controller),
              const Spacer(),
              PrimaryButton(label: 'Recevoir un code', onPressed: () => context.go('/otp')),
            ],
          ),
        ),
      ),
    );
  }
}
