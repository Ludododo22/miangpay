import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/buttons/secondary_button.dart';
import '../../../../core/design_system/empty_states/app_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../transfer/presentation/providers/transfer_providers.dart';

class BeneficiaryDetailScreen extends ConsumerWidget {
  final String beneficiaryId;

  const BeneficiaryDetailScreen({super.key, required this.beneficiaryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beneficiaries = ref.watch(beneficiariesProvider).valueOrNull ?? [];
    final matches = beneficiaries.where((b) => b.id == beneficiaryId);
    final beneficiary = matches.isEmpty ? null : matches.first;

    if (beneficiary == null) {
      return const Scaffold(
        body: AppEmptyState(icon: Icons.person_search_rounded, title: 'Bénéficiaire introuvable', message: 'Ce contact n’existe pas dans les données locales.'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Détail bénéficiaire')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(26)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.secondary.withValues(alpha: .12),
                  child: Text(beneficiary.initials, style: const TextStyle(fontSize: 28, color: AppColors.secondary, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(height: 16),
                Text(beneficiary.fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('${beneficiary.country.flag} ${beneficiary.country.name} • ${beneficiary.operator.name}', style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(beneficiary.phone, style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: _StatCard(label: 'Transferts', value: '12')),
              SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Total envoyé', value: '845k')),
              SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Dernier', value: 'Hier')),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Envoyer de l’argent', icon: Icons.send_rounded, onPressed: () => context.go('/transfer')),
          const SizedBox(height: 12),
          SecondaryButton(label: 'Modifier', icon: Icons.edit_rounded, onPressed: () => context.push('/beneficiaries/new')),
          const SizedBox(height: 24),
          const Text('Historique récent', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          const _MiniHistoryTile(title: 'Aide familiale', amount: '50 000 XOF', date: 'Hier'),
          const _MiniHistoryTile(title: 'Transfert rapide', amount: '25 000 XOF', date: '12 juin'),
          const _MiniHistoryTile(title: 'Urgence', amount: '75 000 XOF', date: '03 juin'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ]),
    );
  }
}

class _MiniHistoryTile extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const _MiniHistoryTile({required this.title, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz_rounded, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(amount, style: const TextStyle(fontWeight: FontWeight.w900)),
            Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
        ],
      ),
    );
  }
}
