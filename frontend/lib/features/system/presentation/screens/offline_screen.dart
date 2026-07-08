import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.wifi_off_rounded, size: 96, color: AppColors.warning),
        const SizedBox(height: 24),
        const Text('Vous êtes hors ligne', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
        const SizedBox(height: 12),
        const Text('Vérifiez votre connexion Internet. Vos données locales restent accessibles.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 28),
        PrimaryButton(label: 'Retour à l’accueil', onPressed: () => context.go('/dashboard')),
      ]),
    ),
  );
}
