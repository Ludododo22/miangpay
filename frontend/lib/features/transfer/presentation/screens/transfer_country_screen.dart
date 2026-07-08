import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';

class TransferCountryScreen extends ConsumerWidget {
  const TransferCountryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countries = ref.watch(countriesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pays d’origine')),
      body: countries.when(
        data: (items) => ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final country = items[index];
            return ListTile(
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              leading: Text(country.flag, style: const TextStyle(fontSize: 30)),
              title: Text(country.name, style: const TextStyle(fontWeight: FontWeight.w900)),
              subtitle: Text('${country.phoneCode} • ${country.currency}'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                ref.read(transferDraftProvider.notifier).setSourceCountry(country);
                context.go('/transfer/beneficiary');
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Erreur de chargement')),
      ),
    );
  }
}
