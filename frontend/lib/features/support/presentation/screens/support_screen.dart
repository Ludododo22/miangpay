import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Support')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const Text('Comment pouvons-nous vous aider ?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
        const SizedBox(height: 8),
        const Text('Retrouvez l’aide, le chat, vos tickets et les contacts utiles.', style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
        const SizedBox(height: 18),
        _SupportTile(icon: Icons.chat_rounded, title: 'Chat support', subtitle: 'Échanger avec l’assistant MiangPay', onTap: () => context.push('/support/chat')),
        _SupportTile(icon: Icons.help_rounded, title: 'FAQ', subtitle: 'Questions fréquentes', onTap: () => context.push('/support/faq')),
        _SupportTile(icon: Icons.receipt_long_rounded, title: 'Mes tickets', subtitle: 'Suivre vos demandes', onTap: () => context.push('/support/tickets')),
        _SupportTile(icon: Icons.add_circle_rounded, title: 'Créer un ticket', subtitle: 'Signaler une transaction ou un problème', onTap: () => context.push('/support/new-ticket')),
        _SupportTile(icon: Icons.phone_rounded, title: 'Nous contacter', subtitle: 'WhatsApp, email, téléphone', onTap: () => context.push('/support/contact')),
      ]),
    );
  }
}

class _SupportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SupportTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [
          CircleAvatar(backgroundColor: AppColors.secondary.withValues(alpha: .12), child: Icon(icon, color: AppColors.secondary)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))])),
          const Icon(Icons.chevron_right_rounded),
        ]),
      ),
    );
  }
}
