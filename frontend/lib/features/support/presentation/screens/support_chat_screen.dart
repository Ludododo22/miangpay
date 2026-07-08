import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/support_providers.dart';

class SupportChatScreen extends ConsumerWidget {
  const SupportChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(supportChatProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Chat support')),
      body: Column(children: [
        Expanded(
          child: messages.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Chat indisponible')),
            data: (items) => ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Align(
                  alignment: item.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 290),
                    decoration: BoxDecoration(
                      color: item.fromUser ? AppColors.secondary : AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(item.message, style: TextStyle(color: item.fromUser ? Colors.white : AppColors.textPrimary, height: 1.4)),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surface,
          child: Row(children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Écrire un message...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(backgroundColor: AppColors.secondary, child: IconButton(onPressed: () {}, icon: const Icon(Icons.send_rounded, color: Colors.white))),
          ]),
        ),
      ]),
    );
  }
}
