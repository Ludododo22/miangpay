class ReceiptModel {
  final String reference;
  final String senderName;
  final String receiverName;
  final String corridor;
  final String operatorName;
  final double amount;
  final double fee;
  final double receivedAmount;
  final String currency;
  final DateTime createdAt;

  const ReceiptModel({
    required this.reference,
    required this.senderName,
    required this.receiverName,
    required this.corridor,
    required this.operatorName,
    required this.amount,
    required this.fee,
    required this.receivedAmount,
    required this.currency,
    required this.createdAt,
  });
}
