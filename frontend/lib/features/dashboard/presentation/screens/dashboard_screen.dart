import 'package:flutter/material.dart';

import '../../../../core/design_system/cards/balance_card.dart';
import '../../../../core/design_system/cards/quick_action_card.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  final bool showBottomNav;

  const DashboardScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour,', style: TextStyle(color: AppColors.textSecondary)),
                        SizedBox(height: 4),
                        Text('Jean Dupont 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
                ],
              ),
              const SizedBox(height: 24),
              const BalanceCard(balance: '245 800 XOF', equivalent: '≈ 374 USD', status: 'KYC validé • Niveau OR'),
              const SizedBox(height: 24),
              const Text('Actions rapides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                  QuickActionCard(label: 'Envoyer', icon: Icons.send_rounded),
                  QuickActionCard(label: 'Recevoir', icon: Icons.call_received_rounded),
                  QuickActionCard(label: 'Retirer', icon: Icons.account_balance_wallet_rounded),
                  QuickActionCard(label: 'Cartes', icon: Icons.credit_card_rounded),
                  QuickActionCard(label: 'Historique', icon: Icons.history_rounded),
                  QuickActionCard(label: 'Promos', icon: Icons.local_offer_rounded),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Activité récente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              _ActivityTile(title: 'Ahmed Diallo', subtitle: 'Gabon → Bénin • Réussi', amount: '-50 000 XOF'),
              _ActivityTile(title: 'Recharge carte', subtitle: 'Aujourd’hui • Réussi', amount: '+25 000 XOF'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const _ActivityTile({required this.title, required this.subtitle, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: AppColors.background, child: Icon(Icons.person_rounded, color: AppColors.secondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
