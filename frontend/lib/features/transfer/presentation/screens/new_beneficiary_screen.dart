import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/beneficiary_form.dart';

class NewBeneficiaryScreen extends StatelessWidget {
  const NewBeneficiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nouveau beneficiaire')),
      body: const BeneficiaryForm(afterSaveRoute: '/transfer/beneficiary'),
    );
  }
}
