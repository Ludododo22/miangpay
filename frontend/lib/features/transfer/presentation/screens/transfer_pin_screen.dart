import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/otp_input.dart';
import '../../../../core/theme/app_colors.dart';

class TransferPinScreen extends StatelessWidget {
  const TransferPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Sécurité')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Spacer(),
          const Icon(Icons.lock_rounded, color: AppColors.secondary, size: 76),
          const SizedBox(height: 24),
          const Text('Entrez votre PIN', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 10),
          const Text('Confirmez ce transfert avec votre code de sécurité.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          const OtpInput(length: 6),
          const Spacer(),
          PrimaryButton(label: 'Valider', icon: Icons.check_rounded, onPressed: () => context.go('/transfer/processing')),
        ]),
      ),
    );
  }
}
