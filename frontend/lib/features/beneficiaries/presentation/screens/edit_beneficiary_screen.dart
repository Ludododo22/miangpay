import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../transfer/presentation/providers/transfer_providers.dart';
import '../../../transfer/presentation/widgets/beneficiary_form.dart';

class EditBeneficiaryScreen extends ConsumerWidget {
  const EditBeneficiaryScreen({super.key, required this.beneficiaryId});

  final String beneficiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beneficiariesAsync = ref.watch(beneficiariesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier beneficiaire')),
      body: beneficiariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(
          icon: Icons.person_search_rounded,
          title: 'Chargement impossible',
          message: 'Ce beneficiaire ne peut pas etre charge.',
        ),
        data: (beneficiaries) {
          final matches =
              beneficiaries.where((item) => item.id == beneficiaryId);
          final beneficiary = matches.isEmpty ? null : matches.first;

          if (beneficiary == null) {
            return const AppEmptyState(
              icon: Icons.person_search_rounded,
              title: 'Beneficiaire introuvable',
              message: 'Ce contact n existe pas dans votre liste.',
            );
          }

          return BeneficiaryForm(
            afterSaveRoute: '/beneficiaries/detail/${beneficiary.id}',
            popAfterSave: true,
            initialBeneficiary: beneficiary,
          );
        },
      ),
    );
  }
}
