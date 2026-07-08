import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class KycRejectedScreen extends StatelessWidget {
  const KycRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('KYC refusé')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Spacer(),
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: .12), shape: BoxShape.circle),
            child: const Icon(Icons.report_problem_rounded, color: AppColors.error, size: 46),
          ),
          const SizedBox(height: 24),
          const Text('Document non accepté', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
          const SizedBox(height: 12),
          const Text('La photo est floue ou une partie du document est masquée. Veuillez soumettre une nouvelle image nette.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
          const Spacer(),
          PrimaryButton(label: 'Reprendre la vérification', onPressed: () => context.go('/kyc-document')),
        ]),
      ),
    );
  }
}
