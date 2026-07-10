import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/buttons/secondary_button.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transfer/data/models/beneficiary_model.dart';
import '../../../transfer/presentation/providers/transfer_providers.dart';

class BeneficiaryDetailScreen extends ConsumerStatefulWidget {
  const BeneficiaryDetailScreen({super.key, required this.beneficiaryId});

  final String beneficiaryId;

  @override
  ConsumerState<BeneficiaryDetailScreen> createState() =>
      _BeneficiaryDetailScreenState();
}

class _BeneficiaryDetailScreenState
    extends ConsumerState<BeneficiaryDetailScreen> {
  bool isBusy = false;

  @override
  Widget build(BuildContext context) {
    final beneficiariesAsync = ref.watch(beneficiariesProvider);

    return beneficiariesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: AppEmptyState(
          icon: Icons.person_search_rounded,
          title: 'Chargement impossible',
          message: 'Ce contact ne peut pas etre charge.',
        ),
      ),
      data: (beneficiaries) {
        final matches =
            beneficiaries.where((b) => b.id == widget.beneficiaryId);
        final beneficiary = matches.isEmpty ? null : matches.first;

        if (beneficiary == null) {
          return const Scaffold(
            body: AppEmptyState(
              icon: Icons.person_search_rounded,
              title: 'Beneficiaire introuvable',
              message: 'Ce contact n existe pas dans les donnees locales.',
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Detail beneficiaire'),
            actions: [
              IconButton(
                tooltip: beneficiary.isFavorite
                    ? 'Retirer des favoris'
                    : 'Ajouter aux favoris',
                onPressed: isBusy ? null : () => _toggleFavorite(beneficiary),
                icon: Icon(
                  beneficiary.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _IdentityCard(beneficiary: beneficiary),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: _StatCard(label: 'Transferts', value: '12')),
                  SizedBox(width: 12),
                  Expanded(
                      child: _StatCard(label: 'Total envoye', value: '845k')),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Dernier', value: 'Hier')),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Envoyer de l argent',
                icon: Icons.send_rounded,
                onPressed: () {
                  ref
                      .read(transferDraftProvider.notifier)
                      .setBeneficiary(beneficiary);
                  context.go('/transfer/countries');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Modifier',
                icon: Icons.edit_rounded,
                onPressed: () =>
                    context.push('/beneficiaries/edit/${beneficiary.id}'),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Supprimer',
                icon: Icons.delete_outline_rounded,
                onPressed: isBusy ? null : () => _confirmDelete(beneficiary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Historique recent',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const _MiniHistoryTile(
                title: 'Aide familiale',
                amount: '50 000 XOF',
                date: 'Hier',
              ),
              const _MiniHistoryTile(
                title: 'Transfert rapide',
                amount: '25 000 XOF',
                date: '12 juin',
              ),
              const _MiniHistoryTile(
                title: 'Urgence',
                amount: '75 000 XOF',
                date: '03 juin',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleFavorite(BeneficiaryModel beneficiary) async {
    setState(() => isBusy = true);
    try {
      await ref
          .read(transferRepositoryProvider)
          .toggleBeneficiaryFavorite(beneficiary.id);
      ref.invalidate(beneficiariesProvider);
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }

  Future<void> _confirmDelete(BeneficiaryModel beneficiary) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le beneficiaire ?'),
        content: Text(
          '${beneficiary.fullName} sera retire de votre liste de contacts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _delete(beneficiary);
  }

  Future<void> _delete(BeneficiaryModel beneficiary) async {
    setState(() => isBusy = true);
    try {
      await ref.read(transferRepositoryProvider).deleteBeneficiary(
            beneficiary.id,
          );
      ref.invalidate(beneficiariesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beneficiaire supprime')),
      );
      context.go('/beneficiaries');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Suppression impossible pour ce beneficiaire'),
        ),
      );
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.beneficiary});

  final BeneficiaryModel beneficiary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.secondary.withValues(alpha: .12),
            child: Text(
              beneficiary.initials,
              style: const TextStyle(
                fontSize: 28,
                color: AppColors.secondary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            beneficiary.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            '${beneficiary.country.flag} ${beneficiary.country.name} - ${beneficiary.operator.name}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            beneficiary.phone,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MiniHistoryTile extends StatelessWidget {
  const _MiniHistoryTile({
    required this.title,
    required this.amount,
    required this.date,
  });

  final String title;
  final String amount;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz_rounded, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
