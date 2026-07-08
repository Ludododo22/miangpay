import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';

class TransferBeneficiaryScreen extends ConsumerWidget {
  const TransferBeneficiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beneficiaries = ref.watch(beneficiariesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Bénéficiaire')),
      body: beneficiaries.when(
        data: (items) => Column(children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final beneficiary = items[index];
                return ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  leading: CircleAvatar(backgroundColor: AppColors.primary, child: Text(beneficiary.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                  title: Text(beneficiary.fullName, style: const TextStyle(fontWeight: FontWeight.w900)),
                  subtitle: Text('${beneficiary.country.flag} ${beneficiary.country.name} • ${beneficiary.operator.name}'),
                  trailing: beneficiary.isFavorite ? const Icon(Icons.star_rounded, color: AppColors.accent) : const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    ref.read(transferDraftProvider.notifier).setBeneficiary(beneficiary);
                    context.go('/transfer/amount');
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: PrimaryButton(label: 'Nouveau bénéficiaire', icon: Icons.person_add_alt_rounded, onPressed: () => context.go('/transfer/new-beneficiary')),
          ),
        ]),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
      ),
    );
  }
}
