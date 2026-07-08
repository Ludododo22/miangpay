import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class OtpInput extends StatelessWidget {
  final int length;
  final ValueChanged<String>? onChanged;

  const OtpInput({
    super.key,
    this.length = 6,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = List.generate(length, (_) => TextEditingController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 48,
          child: TextField(
            controller: controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < length - 1) {
                FocusScope.of(context).nextFocus();
              }
              final code = controllers.map((c) => c.text).join();
              onChanged?.call(code);
            },
          ),
        );
      }),
    );
  }
}
