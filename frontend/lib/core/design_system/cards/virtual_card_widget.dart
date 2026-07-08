import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class VirtualCardWidget extends StatelessWidget {
  final String holder;
  final String balance;
  final String lastDigits;
  final String currency;

  const VirtualCardWidget({super.key, required this.holder, required this.balance, this.lastDigits = '4568', this.currency = 'XOF'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Text('MiangPay Card', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
          Icon(Icons.credit_card_rounded, color: Colors.white),
        ]),
        const SizedBox(height: 28),
        const Text('**** **** **** 4568', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Titulaire', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(holder, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('Solde', style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text('$balance $currency', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ]),
        ])
      ]),
    );
  }
}
