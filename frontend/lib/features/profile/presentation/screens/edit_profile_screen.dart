import 'package:flutter/material.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/theme/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Center(
              child: CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.secondary,
                  child: Text('JD',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24)))),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Sélection de photo initialisée'))),
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Changer la photo'),
          ),
          const SizedBox(height: 18),
          const AppTextField(
              label: 'Nom complet',
              hint: 'Jean Dupont',
              prefixIcon: Icons.person_rounded),
          const SizedBox(height: 14),
          const PhoneField(),
          const SizedBox(height: 14),
          const AppTextField(
              label: 'Email',
              hint: 'jean.dupont@miangpay.demo',
              prefixIcon: Icons.email_rounded),
          const SizedBox(height: 24),
          PrimaryButton(
              label: 'Enregistrer', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
