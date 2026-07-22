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
  bool hasAcceptedLegal = false;
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
                const SizedBox(height: 16),
                _LegalConsentTile(
                  value: hasAcceptedLegal,
                  onChanged: (value) =>
                      setState(() => hasAcceptedLegal = value ?? false),
                  onPrivacyTap: () => _showLegalDocument(
                    title: 'Politique de confidentialite',
                    sections: _privacyPolicySections,
                  ),
                  onTermsTap: () => _showLegalDocument(
                    title: 'Conditions d utilisation',
                    sections: _termsOfUseSections,
                  ),
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

    // L inscription doit prouver que l utilisateur a accepte les textes
    // legaux avant de passer a l OTP, meme lorsque le backend est desactive.
    if (!hasAcceptedLegal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez accepter les conditions et la politique de confidentialite',
          ),
        ),
      );
      return;
    }

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
            termsAccepted: hasAcceptedLegal,
            privacyPolicyAccepted: hasAcceptedLegal,
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
    // L interface affiche des noms lisibles, mais l API attend des codes ISO.
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
    // Les listes de pays/operateurs restent locales pour garder le parcours
    // d inscription utilisable en demo, meme sans appel reseau prealable.
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

  Future<void> _showLegalDocument({
    required String title,
    required List<_LegalSection> sections,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .82,
          minChildSize: .45,
          maxChildSize: .94,
          builder: (context, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Texte de demonstration a faire relire juridiquement avant publication.',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 20),
                for (final section in sections) ...[
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.body,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

const _privacyPolicySections = [
  _LegalSection(
    title: 'Donnees collectees',
    body:
        'MiangPay peut collecter les informations de compte, les donnees KYC, les numeros de telephone, les beneficiaires, les transactions, les tickets support et les informations techniques utiles a la securite.',
  ),
  _LegalSection(
    title: 'Utilisation',
    body:
        'Ces donnees servent a creer le compte, verifier l identite, executer les transferts, proteger le service, assister le client et ameliorer l experience.',
  ),
  _LegalSection(
    title: 'Partage',
    body:
        'Les donnees peuvent etre partagees avec les operateurs de paiement, partenaires de verification, prestataires techniques et autorites competentes lorsque cela est necessaire.',
  ),
  _LegalSection(
    title: 'Droits utilisateur',
    body:
        'L utilisateur peut demander l acces, la correction ou la suppression de ses informations lorsque la loi applicable le permet.',
  ),
];

const _termsOfUseSections = [
  _LegalSection(
    title: 'Compte',
    body:
        'L utilisateur doit fournir des informations exactes, garder ses identifiants confidentiels et signaler toute activite suspecte.',
  ),
  _LegalSection(
    title: 'Transferts',
    body:
        'Les transferts doivent respecter les plafonds, controles KYC, frais affiches et regles des operateurs Mobile Money ou partenaires de paiement.',
  ),
  _LegalSection(
    title: 'Usage interdit',
    body:
        'Le service ne doit pas etre utilise pour fraude, blanchiment, financement illicite, usurpation d identite ou contournement des controles.',
  ),
  _LegalSection(
    title: 'Evolution',
    body:
        'Les conditions peuvent evoluer. Une version production devra etre relue et validee par un conseil juridique avant publication.',
  ),
];

class _LegalSection {
  const _LegalSection({required this.title, required this.body});

  final String title;
  final String body;
}

class _LegalConsentTile extends StatelessWidget {
  const _LegalConsentTile({
    required this.value,
    required this.onChanged,
    required this.onPrivacyTap,
    required this.onTermsTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onPrivacyTap;
  final VoidCallback onTermsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.secondary,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('J accepte les '),
                  InkWell(
                    onTap: onTermsTap,
                    child: const Text(
                      'conditions d utilisation',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Text(' et la '),
                  InkWell(
                    onTap: onPrivacyTap,
                    child: const Text(
                      'politique de confidentialite',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Text('.'),
                ],
              ),
            ),
          ),
        ],
      ),
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
