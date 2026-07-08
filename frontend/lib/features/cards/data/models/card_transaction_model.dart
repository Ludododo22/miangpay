class CardTransactionModel {
  final String id;
  final String cardId;
  final String merchant;
  final String subtitle;
  final double amount;
  final String currency;
  final DateTime createdAt;
  final bool isCredit;
  final String status;

  const CardTransactionModel({
    required this.id,
    required this.cardId,
    required this.merchant,
    required this.subtitle,
    required this.amount,
    required this.currency,
    required this.createdAt,
    required this.isCredit,
    required this.status,
  });
}
