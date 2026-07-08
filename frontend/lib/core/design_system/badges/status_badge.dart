import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

enum AppStatus { success, pending, failed, info }

class StatusBadge extends StatelessWidget {
  final String label;
  final AppStatus status;

  const StatusBadge({super.key, required this.label, this.status = AppStatus.info});

  Color get _color {
    switch (status) {
      case AppStatus.success:
        return AppColors.success;
      case AppStatus.pending:
        return AppColors.warning;
      case AppStatus.failed:
        return AppColors.error;
      case AppStatus.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: _color, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}
