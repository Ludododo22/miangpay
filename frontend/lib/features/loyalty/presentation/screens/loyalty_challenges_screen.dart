import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/loyalty_providers.dart';
import '../widgets/challenge_card.dart';

class LoyaltyChallengesScreen extends ConsumerWidget {
  const LoyaltyChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(loyaltyChallengesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Défis')),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 1,
        mainAxisSpacing: 14,
        childAspectRatio: 1.9,
        children: [for (final challenge in challenges) ChallengeCard(challenge: challenge)],
      ),
    );
  }
}
