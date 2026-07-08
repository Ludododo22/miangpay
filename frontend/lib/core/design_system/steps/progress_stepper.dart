import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final active = index <= currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
            height: 6,
            decoration: BoxDecoration(
              color: active ? AppColors.secondary : AppColors.secondary.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
