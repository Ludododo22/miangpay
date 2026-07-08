import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TransferTimeline extends StatelessWidget {
  final int activeStep;
  const TransferTimeline({super.key, this.activeStep = 3});

  @override
  Widget build(BuildContext context) {
    const steps = ['Création', 'Validation', 'PAWAPAY', 'Livraison'];
    return Column(
      children: List.generate(steps.length, (index) {
        final done = index <= activeStep;
        return Row(children: [
          CircleAvatar(radius: 14, backgroundColor: done ? AppColors.secondary : const Color(0xFFE5E7EB), child: Icon(done ? Icons.check : Icons.more_horiz, size: 16, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(child: Text(steps[index], style: const TextStyle(fontWeight: FontWeight.w800))),
          Text(done ? 'OK' : 'En attente', style: const TextStyle(color: AppColors.textSecondary)),
        ]);
      }).expand((row) => [row, const SizedBox(height: 14)]).toList(),
    );
  }
}
