import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/transfer_providers.dart';
import '../widgets/transfer_timeline.dart';

class TransferProcessingScreen extends ConsumerStatefulWidget {
  const TransferProcessingScreen({super.key});

  @override
  ConsumerState<TransferProcessingScreen> createState() => _TransferProcessingScreenState();
}

class _TransferProcessingScreenState extends ConsumerState<TransferProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 500), () async {
      await ref.read(transferDraftProvider.notifier).submit();
      if (mounted) context.go('/transfer/success');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(children: [
            Spacer(),
            CircularProgressIndicator(color: AppColors.secondary),
            SizedBox(height: 28),
            Text('Transfert en cours', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary)),
            SizedBox(height: 10),
            Text('Nous traitons votre opération de façon sécurisée.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
            SizedBox(height: 32),
            TransferTimeline(activeStep: 2),
            Spacer(),
          ]),
        ),
      ),
    );
  }
}
