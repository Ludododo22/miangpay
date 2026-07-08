import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class BeneficiaryCard extends StatelessWidget {
  final String initials;
  final String name;
  final String details;
  final VoidCallback? onSend;
  final VoidCallback? onTap;

  const BeneficiaryCard({super.key, required this.initials, required this.name, required this.details, this.onSend, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: AppColors.secondary.withValues(alpha: .12), child: Text(initials, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w900))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(details, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ])),
            TextButton(onPressed: onSend, child: const Text('Envoyer')),
          ],
        ),
      ),
    );
  }
}
