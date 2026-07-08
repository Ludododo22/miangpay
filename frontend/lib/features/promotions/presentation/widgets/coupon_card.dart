import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/coupon_model.dart';

class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(color: coupon.used ? Colors.grey.shade200 : AppColors.accent.withValues(alpha: .16), borderRadius: BorderRadius.circular(16)),
            child: Icon(Icons.confirmation_number_rounded, color: coupon.used ? AppColors.textSecondary : AppColors.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(coupon.label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 4),
              Text(coupon.benefit, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 6),
              Text(coupon.code, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
            ]),
          ),
          Text(coupon.expiry, textAlign: TextAlign.right, style: TextStyle(color: coupon.used ? AppColors.error : AppColors.secondary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
