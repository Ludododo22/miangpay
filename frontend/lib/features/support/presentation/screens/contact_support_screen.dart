import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = const [
      (Icons.chat_rounded, 'WhatsApp', '+229 00 00 00 00'),
      (Icons.email_rounded, 'Email', 'support@miangpay.com'),
      (Icons.phone_rounded, 'Téléphone', 'Disponible 8h–20h'),
      (Icons.location_on_rounded, 'Bureau', 'Cotonou, Bénin'),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nous contacter')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: contacts.map((contact) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18)),
          child: Row(children: [
            CircleAvatar(backgroundColor: AppColors.secondary.withValues(alpha: .12), child: Icon(contact.$1, color: AppColors.secondary)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(contact.$2, style: const TextStyle(fontWeight: FontWeight.w900)), Text(contact.$3, style: const TextStyle(color: AppColors.textSecondary))])),
            const Icon(Icons.chevron_right_rounded),
          ]),
        )).toList(),
      ),
    );
  }
}
