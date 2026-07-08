import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SettingSectionTitle extends StatelessWidget {
  final String title;
  const SettingSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w900, letterSpacing: .8)),
    );
  }
}
