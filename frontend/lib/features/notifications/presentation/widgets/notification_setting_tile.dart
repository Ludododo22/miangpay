import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class NotificationSettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;

  const NotificationSettingTile({super.key, required this.title, required this.subtitle, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ),
          Switch(value: value, onChanged: (_) {}),
        ],
      ),
    );
  }
}
