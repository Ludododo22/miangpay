import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/promotion_model.dart';

class PromotionOfferCard extends StatelessWidget {
  final PromotionModel promotion;
  final VoidCallback? onTap;

  const PromotionOfferCard({super.key, required this.promotion, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: promotion.isFeatured ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: promotion.isFeatured ? AppColors.secondary : AppColors.secondary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    promotion.tag,
                    style: TextStyle(
                      color: promotion.isFeatured ? Colors.white : AppColors.secondary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  promotion.corridor,
                  style: TextStyle(color: promotion.isFeatured ? Colors.white70 : AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              promotion.title,
              style: TextStyle(
                color: promotion.isFeatured ? Colors.white : AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              promotion.description,
              style: TextStyle(
                color: promotion.isFeatured ? Colors.white70 : AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 18, color: promotion.isFeatured ? Colors.white70 : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(promotion.expiresAt, style: TextStyle(color: promotion.isFeatured ? Colors.white70 : AppColors.textSecondary)),
                const Spacer(),
                Text('${promotion.remainingUses} utilisations', style: TextStyle(color: promotion.isFeatured ? Colors.white : AppColors.secondary, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
