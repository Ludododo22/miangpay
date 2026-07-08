import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';

class NewTicketScreen extends StatelessWidget {
  const NewTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nouveau ticket')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        const Text('Décrivez votre problème', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
        const SizedBox(height: 16),
        const AppTextField(label: 'Sujet', hint: 'Ex: Transfert en attente'),
        const SizedBox(height: 16),
        const AppTextField(label: 'Catégorie', hint: 'Transaction, carte, KYC, compte...'),
        const SizedBox(height: 16),
        TextField(
          minLines: 5,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: 'Message',
            hintText: 'Ajoutez les détails utiles pour le support.',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Envoyer le ticket',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket créé avec succès')));
            context.pop();
          },
        ),
      ]),
    );
  }
}
