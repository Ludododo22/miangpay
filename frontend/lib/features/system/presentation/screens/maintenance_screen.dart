import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors.background,
    body: Padding(
      padding: EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.construction_rounded, size: 96, color: AppColors.secondary),
        SizedBox(height: 24),
        Text('Maintenance en cours', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
        SizedBox(height: 12),
        Text('MiangPay revient bientôt. Les transferts et cartes sont momentanément indisponibles.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
      ]),
    ),
  );
}
