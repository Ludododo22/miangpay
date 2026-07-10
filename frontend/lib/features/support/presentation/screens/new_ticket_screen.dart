import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/buttons/primary_button.dart';
import '../../../../core/design_system/inputs/app_text_field.dart';
import '../../../../core/forms/form_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/support_providers.dart';

class NewTicketScreen extends ConsumerStatefulWidget {
  const NewTicketScreen({super.key});

  @override
  ConsumerState<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends ConsumerState<NewTicketScreen> {
  final formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final categoryController = TextEditingController();
  final messageController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    subjectController.dispose();
    categoryController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nouveau ticket')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Decrivez votre probleme',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Sujet',
              hint: 'Ex: Transfert en attente',
              controller: subjectController,
              validator: FormValidators.required,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Categorie',
              hint: 'Transaction, carte, KYC, compte...',
              controller: categoryController,
              validator: FormValidators.required,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: messageController,
              minLines: 5,
              maxLines: 8,
              validator: FormValidators.required,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Ajoutez les details utiles pour le support.',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Envoyer le ticket',
              isLoading: isSubmitting,
              onPressed: isSubmitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isSubmitting = true);
    try {
      await ref.read(supportRepositoryProvider).createTicket(
            subject: subjectController.text.trim(),
            category: categoryController.text.trim(),
            message: messageController.text.trim(),
          );
      ref.invalidate(supportTicketsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket cree avec succes')),
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de creer le ticket')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }
}
