import 'package:flutter/material.dart';

class AppSkeleton extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const AppSkeleton({super.key, required this.height, this.width, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
