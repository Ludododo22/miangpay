import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/otp_input.dart';
import '../../../../core/theme/app_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Vérification OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                height: 84,
                width: 84,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 42),
              ),
              const SizedBox(height: 28),
              const Text(
                'Confirmez votre numéro',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Entrez le code à 6 chiffres envoyé par SMS. Ce code expire dans 02:00.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              OtpInput(onChanged: (value) => setState(() => code = value)),
              const SizedBox(height: 20),
              Center(
                child: TextButton(onPressed: () {}, child: const Text('Renvoyer le code')),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Valider',
                onPressed: code.length == 6 ? () => context.go('/kyc-intro') : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
