import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../transfer/presentation/widgets/beneficiary_form.dart';

class AddBeneficiaryScreen extends StatelessWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nouveau beneficiaire')),
      body: const BeneficiaryForm(
        afterSaveRoute: '/beneficiaries',
        popAfterSave: true,
      ),
    );
  }
}
