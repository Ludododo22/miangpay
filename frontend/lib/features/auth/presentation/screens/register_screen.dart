import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/forms/form_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String country = 'Benin';
  String operator = 'MTN Mobile Money';
  bool isSubmitting = false;

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
      appBar: AppBar(title: const Text('Creer un compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue sur MiangPay',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Creez votre compte pour envoyer de l'argent en Afrique.",
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Prenom',
                        controller: firstNameController,
                        validator: FormValidators.required,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextField(
                        label: 'Nom',
                        controller: lastNameController,
                        validator: FormValidators.required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PhoneField(
                  controller: phoneController,
                  validator: FormValidators.phone,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  controller: emailController,
                  prefixIcon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidators.email,
                ),
                const SizedBox(height: 16),
                _SelectorTile(
                  icon: Icons.flag_rounded,
                  label: 'Pays de residence',
                  value: country,
                  onTap: () => _selectValue(
                    title: 'Pays de residence',
                    values: const [
                      'Benin',
                      'Gabon',
                      "Cote d'Ivoire",
                      'Senegal',
                      'Cameroun',
                      'Togo',
                    ],
                    currentValue: country,
                    onSelected: (value) => setState(() => country = value),
                  ),
                ),
                const SizedBox(height: 12),
                _SelectorTile(
                  icon: Icons.phone_android_rounded,
                  label: 'Operateur Mobile Money',
                  value: operator,
                  onTap: () => _selectValue(
                    title: 'Operateur Mobile Money',
                    values: const [
                      'MTN Mobile Money',
                      'Orange Money',
                      'Moov Money',
                      'Airtel Money',
                      'Free Money',
                      'Flooz',
                    ],
                    currentValue: operator,
                    onSelected: (value) => setState(() => operator = value),
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Mot de passe',
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_rounded,
                  validator: FormValidators.password,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: isSubmitting ? 'Creation...' : 'Creer mon compte',
                  onPressed: isSubmitting ? null : _submit,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Deja un compte ? Se connecter'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final phone = phoneController.text.trim();
    if (ref.read(dataSourceModeProvider) == DataSourceMode.fake) {
      context.go('/otp?phone=${Uri.encodeComponent(phone)}');
      return;
    }

    setState(() => isSubmitting = true);
    try {
      final email = emailController.text.trim();
      await ref.read(authApiRepositoryProvider).register(
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
            phone: phone,
            email: email.isEmpty ? null : email,
            country: _countryCode(country),
            operator: operator,
            password: passwordController.text,
          );
      if (mounted) context.go('/otp?phone=${Uri.encodeComponent(phone)}');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creation du compte impossible')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  String _countryCode(String value) {
    if (value == 'Gabon') return 'GA';
    if (value == "Cote d'Ivoire") return 'CI';
    if (value == 'Senegal') return 'SN';
    if (value == 'Cameroun') return 'CM';
    if (value == 'Togo') return 'TG';
    return 'BJ';
  }

  Future<void> _selectValue({
    required String title,
    required List<String> values,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              for (final value in values)
                ListTile(
                  title: Text(value),
                  trailing: value == currentValue
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: () {
                    onSelected(value);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SelectorTile extends StatelessWidget {
  const _SelectorTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
