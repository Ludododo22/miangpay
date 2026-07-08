import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const QuickActionCard({super.key, required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.secondary, size: 30),
            const SizedBox(height: 10),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
