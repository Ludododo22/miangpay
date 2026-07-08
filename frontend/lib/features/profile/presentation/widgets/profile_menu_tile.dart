import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: .10), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ]),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
