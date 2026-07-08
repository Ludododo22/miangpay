import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showName;

  const AppLogo({super.key, this.size = 72, this.showName = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(22)),
          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 38),
        ),
        if (showName) ...[
          const SizedBox(height: 16),
          const Text(
            'MiangPay',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.primary),
          ),
        ],
      ],
    );
  }
}
