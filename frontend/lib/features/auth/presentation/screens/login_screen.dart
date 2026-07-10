import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/design_system/logo/app_logo.dart';
import '../../../../core/forms/form_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSubmitting = false;

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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 32),
                const AppLogo(size: 70),
                const SizedBox(height: 40),
                PhoneField(
                    controller: phoneController,
                    validator: FormValidators.phone),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Mot de passe',
                  hint: 'Votre mot de passe',
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_rounded,
                  validator: FormValidators.password,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: isSubmitting ? 'Connexion...' : 'Se connecter',
                  onPressed: isSubmitting ? null : _submit,
                ),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: const Text('Mot de passe oublié ?')),
                TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text('Créer un compte MiangPay')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (ref.read(dataSourceModeProvider) == DataSourceMode.fake) {
      context.go('/dashboard');
      return;
    }

    setState(() => isSubmitting = true);
    try {
      await ref.read(authApiRepositoryProvider).login(
            phone: phoneController.text.trim(),
            password: passwordController.text,
          );
      if (mounted) context.go('/dashboard');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion impossible pour le moment')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }
}
