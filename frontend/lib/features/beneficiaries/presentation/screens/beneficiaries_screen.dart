import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transfer/data/models/beneficiary_model.dart';
import '../../../transfer/presentation/providers/transfer_providers.dart';

class BeneficiariesScreen extends ConsumerWidget {
  const BeneficiariesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beneficiariesAsync = ref.watch(beneficiariesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Bénéficiaires')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/beneficiaries/new'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ajouter'),
      ),
      body: beneficiariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(icon: Icons.people_outline_rounded, title: 'Chargement impossible', message: 'Les bénéficiaires ne sont pas disponibles.'),
        data: (beneficiaries) {
          final favorites = beneficiaries.where((b) => b.isFavorite).toList();
          final others = beneficiaries.where((b) => !b.isFavorite).toList();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const AppTextField(label: 'Rechercher', hint: 'Nom, pays, opérateur...', prefixIcon: Icons.search_rounded),
              const SizedBox(height: 24),
              if (favorites.isNotEmpty) ...[
                const Text('Favoris', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                ...favorites.map((beneficiary) => _BeneficiaryListTile(beneficiary: beneficiary)),
                const SizedBox(height: 20),
              ],
              const Text('Tous', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              ...others.map((beneficiary) => _BeneficiaryListTile(beneficiary: beneficiary)),
            ],
          );
        },
      ),
    );
  }
}

class _BeneficiaryListTile extends StatelessWidget {
  final BeneficiaryModel beneficiary;

  const _BeneficiaryListTile({required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/beneficiaries/detail/${beneficiary.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primary.withValues(alpha: .08),
              child: Text(beneficiary.initials, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Flexible(child: Text(beneficiary.fullName, style: const TextStyle(fontWeight: FontWeight.w900))),
                    if (beneficiary.isFavorite) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                    ],
                  ]),
                  const SizedBox(height: 5),
                  Text('${beneficiary.country.flag} ${beneficiary.country.name} • ${beneficiary.operator.name}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text(beneficiary.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.go('/transfer'),
              icon: const Icon(Icons.send_rounded, color: AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
