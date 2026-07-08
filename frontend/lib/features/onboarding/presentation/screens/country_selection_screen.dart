import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  String selectedCountry = 'BJ';

  final countries = const [
    {'code': 'BJ', 'name': 'Bénin', 'flag': '🇧🇯', 'currency': 'XOF'},
    {'code': 'GA', 'name': 'Gabon', 'flag': '🇬🇦', 'currency': 'XAF'},
    {'code': 'CI', 'name': 'Côte d’Ivoire', 'flag': '🇨🇮', 'currency': 'XOF'},
    {'code': 'SN', 'name': 'Sénégal', 'flag': '🇸🇳', 'currency': 'XOF'},
    {'code': 'CM', 'name': 'Cameroun', 'flag': '🇨🇲', 'currency': 'XAF'},
    {'code': 'TG', 'name': 'Togo', 'flag': '🇹🇬', 'currency': 'XOF'},
    {'code': 'ML', 'name': 'Mali', 'flag': '🇲🇱', 'currency': 'XOF'},
    {'code': 'BF', 'name': 'Burkina Faso', 'flag': '🇧🇫', 'currency': 'XOF'},
    {'code': 'NE', 'name': 'Niger', 'flag': '🇳🇪', 'currency': 'XOF'},
    {'code': 'CD', 'name': 'RDC', 'flag': '🇨🇩', 'currency': 'CDF'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Choisir votre pays')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Sélectionnez votre pays de résidence pour personnaliser votre expérience MiangPay.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: countries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final country = countries[index];
                  final isSelected = selectedCountry == country['code'];
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => selectedCountry = country['code']!),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppColors.secondary : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(country['flag']!, style: const TextStyle(fontSize: 30)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              country['name']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(country['currency']!, style: const TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            PrimaryButton(label: 'Continuer', onPressed: () => context.go('/login')),
          ],
        ),
      ),
    );
  }
}
