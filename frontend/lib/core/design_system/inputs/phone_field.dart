import 'package:flutter/material.dart';

import 'app_text_field.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const PhoneField({super.key, this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'Numéro de téléphone',
      hint: '+229 00 00 00 00',
      controller: controller,
      prefixIcon: Icons.phone_android_rounded,
      keyboardType: TextInputType.phone,
      validator: validator,
    );
  }
}
