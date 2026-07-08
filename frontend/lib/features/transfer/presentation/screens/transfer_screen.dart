import 'package:flutter/material.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/cards/beneficiary_card.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Transfert')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Envoyer de l’argent', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Choisissez un bénéficiaire et vérifiez les frais avant de confirmer.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 24),
          const AppTextField(label: 'Montant', hint: '50 000', prefixIcon: Icons.payments_rounded, keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
            child: const Column(children: [
              _FeeRow(label: 'Frais', value: '1 250 XOF'),
              _FeeRow(label: 'Taux', value: '1 XAF = 1 XOF'),
              Divider(height: 26),
              _FeeRow(label: 'Le bénéficiaire reçoit', value: '48 750 XOF', isTotal: true),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Bénéficiaires favoris', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          const BeneficiaryCard(initials: 'AD', name: 'Ahmed Diallo', details: '🇧🇯 Bénin • MTN'),
          const BeneficiaryCard(initials: 'FK', name: 'Fatou Koffi', details: '🇨🇮 Côte d’Ivoire • Orange'),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Continuer', icon: Icons.arrow_forward_rounded, onPressed: () {}),
        ]),
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _FeeRow({required this.label, required this.value, this.isTotal = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: isTotal ? AppColors.textPrimary : AppColors.textSecondary, fontWeight: isTotal ? FontWeight.w900 : FontWeight.w500)),
        Text(value, style: TextStyle(color: isTotal ? AppColors.secondary : AppColors.textPrimary, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}
