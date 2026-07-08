import 'package:flutter/material.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.system_update_rounded, size: 96, color: AppColors.secondary),
        const SizedBox(height: 24),
        const Text('Mise à jour requise', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
        const SizedBox(height: 12),
        const Text('Installez la dernière version pour continuer à utiliser MiangPay en toute sécurité.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 28),
        PrimaryButton(label: 'Mettre à jour', onPressed: () {}),
      ]),
    ),
  );
}
