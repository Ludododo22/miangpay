import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/receipt_model.dart';

class ReceiptCard extends StatelessWidget {
  final ReceiptModel receipt;
  const ReceiptCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy HH:mm').format(receipt.createdAt);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(child: Icon(Icons.verified_rounded, color: AppColors.secondary, size: 56)),
        const SizedBox(height: 12),
        const Center(child: Text('Reçu MiangPay', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary))),
        const SizedBox(height: 20),
        _line('Référence', receipt.reference),
        _line('Date', date),
        _line('Expéditeur', receipt.senderName),
        _line('Bénéficiaire', receipt.receiverName),
        _line('Corridor', receipt.corridor),
        _line('Opérateur', receipt.operatorName),
        const Divider(height: 28),
        _line('Montant', '${receipt.amount.toStringAsFixed(0)} ${receipt.currency}', important: true),
        _line('Frais', '${receipt.fee.toStringAsFixed(0)} ${receipt.currency}'),
        _line('Reçu', receipt.receivedAmount.toStringAsFixed(0), important: true),
      ]),
    );
  }

  Widget _line(String label, String value, {bool important = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: TextStyle(fontWeight: important ? FontWeight.w900 : FontWeight.w700, color: important ? AppColors.secondary : AppColors.textPrimary))),
      ]),
    );
  }
}
