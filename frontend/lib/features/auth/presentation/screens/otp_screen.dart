import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_providers.dart';
import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/otp_input.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, this.phone});

  final String? phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String code = '';
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Vérification OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                height: 84,
                width: 84,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.verified_user_rounded,
                    color: AppColors.secondary, size: 42),
              ),
              const SizedBox(height: 28),
              const Text(
                'Confirmez votre numéro',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'Entrez le code à 6 chiffres envoyé par SMS. Ce code expire dans 02:00.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 32),
              OtpInput(onChanged: (value) => setState(() => code = value)),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code renvoyé')));
                  },
                  child: const Text('Renvoyer le code'),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: isSubmitting ? 'Verification...' : 'Valider',
                onPressed: code.length == 6 && !isSubmitting ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (ref.read(dataSourceModeProvider) == DataSourceMode.fake ||
        widget.phone == null) {
      context.go('/kyc-intro');
      return;
    }

    setState(() => isSubmitting = true);
    try {
      await ref.read(authApiRepositoryProvider).verifyOtp(
            phone: widget.phone!,
            code: code,
          );
      if (mounted) context.go('/kyc-intro');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code OTP invalide ou expire')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }
}
