import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AmountInputCard extends StatelessWidget {
  final String currency;
  final ValueChanged<double> onChanged;

  const AmountInputCard({super.key, required this.currency, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Montant à envoyer', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
        TextField(
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: AppColors.primary),
          decoration: InputDecoration(
            suffixText: currency,
            suffixStyle: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.secondary),
            border: InputBorder.none,
            hintText: '50 000',
          ),
          onChanged: (value) => onChanged(double.tryParse(value.replaceAll(' ', '')) ?? 0),
        ),
        Wrap(spacing: 8, children: [10000, 25000, 50000, 100000].map((amount) => ActionChip(
          label: Text('${amount ~/ 1000}k'),
          onPressed: () => onChanged(amount.toDouble()),
        )).toList()),
      ]),
    );
  }
}
