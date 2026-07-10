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
      appBar: AppBar(title: const Text('Beneficiaires')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/beneficiaries/new'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ajouter'),
      ),
      body: beneficiariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const AppEmptyState(
          icon: Icons.people_outline_rounded,
          title: 'Chargement impossible',
          message: 'Les beneficiaires ne sont pas disponibles.',
        ),
        data: (beneficiaries) {
          final favorites = beneficiaries.where((b) => b.isFavorite).toList();
          final others = beneficiaries.where((b) => !b.isFavorite).toList();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const AppTextField(
                label: 'Rechercher',
                hint: 'Nom, pays, operateur...',
                prefixIcon: Icons.search_rounded,
              ),
              const SizedBox(height: 24),
              if (favorites.isNotEmpty) ...[
                const _SectionTitle('Favoris'),
                const SizedBox(height: 12),
                ...favorites.map(
                  (beneficiary) =>
                      _BeneficiaryListTile(beneficiary: beneficiary),
                ),
                const SizedBox(height: 20),
              ],
              const _SectionTitle('Tous'),
              const SizedBox(height: 12),
              if (others.isEmpty && favorites.isEmpty)
                const AppEmptyState(
                  icon: Icons.person_add_alt_rounded,
                  title: 'Aucun beneficiaire',
                  message: 'Ajoutez un contact pour accelerer vos transferts.',
                )
              else
                ...others.map(
                  (beneficiary) =>
                      _BeneficiaryListTile(beneficiary: beneficiary),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );
  }
}

class _BeneficiaryListTile extends ConsumerWidget {
  const _BeneficiaryListTile({required this.beneficiary});

  final BeneficiaryModel beneficiary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/beneficiaries/detail/${beneficiary.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.primary.withValues(alpha: .08),
              child: Text(
                beneficiary.initials,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          beneficiary.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      if (beneficiary.isFavorite) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.accent,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${beneficiary.country.flag} ${beneficiary.country.name} - ${beneficiary.operator.name}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    beneficiary.phone,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: beneficiary.isFavorite
                  ? 'Retirer des favoris'
                  : 'Ajouter aux favoris',
              onPressed: () => _toggleFavorite(context, ref),
              icon: Icon(
                beneficiary.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: AppColors.accent,
              ),
            ),
            IconButton(
              tooltip: 'Envoyer',
              onPressed: () {
                ref
                    .read(transferDraftProvider.notifier)
                    .setBeneficiary(beneficiary);
                context.go('/transfer/countries');
              },
              icon: const Icon(Icons.send_rounded, color: AppColors.secondary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(transferRepositoryProvider)
          .toggleBeneficiaryFavorite(beneficiary.id);
      ref.invalidate(beneficiariesProvider);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mise a jour du favori impossible')),
      );
    }
  }
}
