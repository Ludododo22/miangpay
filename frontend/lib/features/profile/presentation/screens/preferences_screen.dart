import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/setting_section_title.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String language = 'Français';
  String currency = 'XOF';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Langue & devise')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SettingSectionTitle('Langue'),
          ...['Français', 'English'].map((item) => _ChoiceRow(label: item, selected: language == item, onTap: () => setState(() => language = item))),
          const SettingSectionTitle('Devise d’affichage'),
          ...['XOF', 'XAF', 'USD', 'EUR'].map((item) => _ChoiceRow(label: item, selected: currency == item, onTap: () => setState(() => currency = item))),
        ],
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceRow({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? AppColors.secondary : Colors.transparent, width: 1.4),
        ),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))),
          if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.secondary),
        ]),
      ),
    );
  }
}
