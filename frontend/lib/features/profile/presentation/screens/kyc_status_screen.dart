import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/badges/status_badge.dart';
import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class KycStatusScreen extends StatelessWidget {
  const KycStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Statut KYC')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.verified_rounded, color: AppColors.success, size: 32), SizedBox(width: 12), Expanded(child: Text('Compte vérifié', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))), StatusBadge(label: 'Validé', status: AppStatus.success)]),
              SizedBox(height: 12),
              Text('Votre identité est validée. Vous pouvez utiliser les transferts, les cartes virtuelles et les limites standard MiangPay.', style: TextStyle(color: AppColors.textSecondary, height: 1.45)),
            ]),
          ),
          const SizedBox(height: 18),
          _KycRow(title: 'Identité', value: 'Jean Dupont', status: 'Vérifiée'),
          _KycRow(title: 'Document', value: 'Carte nationale d’identité', status: 'Valide'),
          _KycRow(title: 'Adresse', value: 'Cotonou, Bénin', status: 'Vérifiée'),
          _KycRow(title: 'Expiration', value: '12/2029', status: 'OK'),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Mettre à jour les documents', onPressed: () => context.push('/kyc-intro')),
        ],
      ),
    );
  }
}

class _KycRow extends StatelessWidget {
  final String title;
  final String value;
  final String status;
  const _KycRow({required this.title, required this.value, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ])),
        StatusBadge(label: status, status: AppStatus.success),
      ]),
    );
  }
}
