import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/design_system/logo/app_logo.dart';
import '../../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const AppLogo(size: 70),
              const SizedBox(height: 40),
              PhoneField(controller: phoneController),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Mot de passe',
                hint: 'Votre mot de passe',
                controller: passwordController,
                obscureText: true,
                prefixIcon: Icons.lock_rounded,
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Se connecter', onPressed: () => context.go('/dashboard')),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.go('/forgot-password'), child: const Text('Mot de passe oublié ?')),
              TextButton(onPressed: () => context.go('/register'), child: const Text('Créer un compte MiangPay')), 
            ],
          ),
        ),
      ),
    );
  }
}
