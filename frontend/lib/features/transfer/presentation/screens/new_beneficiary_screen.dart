import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/theme/app_colors.dart';

class NewBeneficiaryScreen extends StatelessWidget {
  const NewBeneficiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nouveau bénéficiaire')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const AppTextField(label: 'Nom complet', hint: 'Ex: Ahmed Diallo', prefixIcon: Icons.person_rounded),
          const SizedBox(height: 16),
          const PhoneField(),
          const SizedBox(height: 16),
          const AppTextField(label: 'Pays', hint: 'Bénin', prefixIcon: Icons.flag_rounded),
          const SizedBox(height: 16),
          const AppTextField(label: 'Opérateur', hint: 'MTN Mobile Money', prefixIcon: Icons.phone_android_rounded),
          const SizedBox(height: 24),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Ajouter aux favoris', style: TextStyle(fontWeight: FontWeight.w800)),
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Enregistrer', onPressed: () => context.go('/transfer/beneficiary')),
        ]),
      ),
    );
  }
}
