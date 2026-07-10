import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/design_system/inputs/phone_field.dart';
import '../../../../core/forms/form_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/country_model.dart';
import '../../data/models/operator_model.dart';
import '../providers/transfer_providers.dart';

class BeneficiaryForm extends ConsumerStatefulWidget {
  const BeneficiaryForm({
    super.key,
    required this.afterSaveRoute,
    this.popAfterSave = false,
  });

  final String afterSaveRoute;
  final bool popAfterSave;

  @override
  ConsumerState<BeneficiaryForm> createState() => _BeneficiaryFormState();
}

class _BeneficiaryFormState extends ConsumerState<BeneficiaryForm> {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  String? countryCode;
  String? operatorId;
  bool isFavorite = true;
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countriesAsync = ref.watch(countriesProvider);
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppTextField(
            label: 'Nom complet',
            hint: 'Ex: Ahmed Diallo',
            controller: fullNameController,
            prefixIcon: Icons.person_rounded,
            validator: FormValidators.required,
          ),
          const SizedBox(height: 16),
          PhoneField(
            controller: phoneController,
            validator: FormValidators.phone,
          ),
          const SizedBox(height: 16),
          countriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Pays indisponibles'),
            data: (countries) {
              final selectedCountry = _selectedCountry(countries);
              final operatorsAsync = selectedCountry == null
                  ? null
                  : ref.watch(operatorsProvider(selectedCountry.code));
              return Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedCountry?.code,
                    decoration: _decoration('Pays'),
                    items: [
                      for (final country in countries)
                        DropdownMenuItem(
                          value: country.code,
                          child: Text('${country.flag} ${country.name}'),
                        ),
                    ],
                    validator: FormValidators.required,
                    onChanged: (value) {
                      setState(() {
                        countryCode = value;
                        operatorId = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  operatorsAsync == null
                      ? const SizedBox.shrink()
                      : operatorsAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) =>
                              const Text('Operateurs indisponibles'),
                          data: (operators) {
                            final selectedOperator =
                                _selectedOperator(operators);
                            return DropdownButtonFormField<String>(
                              initialValue: selectedOperator?.id,
                              decoration: _decoration('Operateur'),
                              items: [
                                for (final operator in operators)
                                  DropdownMenuItem(
                                    value: operator.id,
                                    child: Text(operator.name),
                                  ),
                              ],
                              validator: FormValidators.required,
                              onChanged: (value) =>
                                  setState(() => operatorId = value),
                            );
                          },
                        ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: isFavorite,
            onChanged: (value) => setState(() => isFavorite = value),
            activeThumbColor: AppColors.secondary,
            title: const Text(
              'Ajouter aux favoris',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Enregistrer',
            icon: Icons.check_rounded,
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : _submit,
          ),
        ],
      ),
    );
  }

  CountryModel? _selectedCountry(List<CountryModel> countries) {
    if (countries.isEmpty) return null;
    final code = countryCode ?? countries.first.code;
    countryCode ??= code;
    return countries.firstWhere(
      (country) => country.code == code,
      orElse: () => countries.first,
    );
  }

  OperatorModel? _selectedOperator(List<OperatorModel> operators) {
    if (operators.isEmpty) return null;
    final id = operatorId ?? operators.first.id;
    operatorId ??= id;
    return operators.firstWhere(
      (operator) => operator.id == id,
      orElse: () => operators.first,
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final countries = ref.read(countriesProvider).valueOrNull ?? [];
    final selectedCountry = _selectedCountry(countries);
    if (selectedCountry == null) return;
    final operators =
        ref.read(operatorsProvider(selectedCountry.code)).valueOrNull ?? [];
    final selectedOperator = _selectedOperator(operators);
    if (selectedOperator == null) return;

    setState(() => isSubmitting = true);
    try {
      await ref.read(transferRepositoryProvider).createBeneficiary(
            fullName: fullNameController.text.trim(),
            phone: phoneController.text.trim(),
            country: selectedCountry,
            operator: selectedOperator,
            isFavorite: isFavorite,
          );
      ref.invalidate(beneficiariesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beneficiaire enregistre')),
      );
      if (widget.popAfterSave) {
        context.pop();
      } else {
        context.go(widget.afterSaveRoute);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Impossible d enregistrer le beneficiaire')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }
}
