import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';

class KycPendingScreen extends StatelessWidget {
  const KycPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppEmptyState(
        icon: Icons.hourglass_top_rounded,
        title: 'Vérification en cours',
        message: 'Votre dossier KYC est en analyse. Vous serez notifié dès validation.',
        action: PrimaryButton(label: 'Aller au tableau de bord', onPressed: () => context.go('/dashboard')),
      ),
    );
  }
}
