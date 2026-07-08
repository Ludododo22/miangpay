import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String country = 'Bénin';
  String operator = 'MTN Mobile Money';

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue sur MiangPay',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Créez votre compte pour envoyer de l’argent en Afrique.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Prénom', controller: firstNameController)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Nom', controller: lastNameController)),
                ],
              ),
              const SizedBox(height: 16),
              PhoneField(controller: phoneController),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email',
                controller: emailController,
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _SelectorTile(
                icon: Icons.flag_rounded,
                label: 'Pays de résidence',
                value: country,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _SelectorTile(
                icon: Icons.phone_android_rounded,
                label: 'Opérateur Mobile Money',
                value: operator,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Mot de passe',
                controller: passwordController,
                obscureText: true,
                prefixIcon: Icons.lock_rounded,
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Créer mon compte', onPressed: () => context.go('/otp')),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Déjà un compte ? Se connecter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SelectorTile({required this.icon, required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
