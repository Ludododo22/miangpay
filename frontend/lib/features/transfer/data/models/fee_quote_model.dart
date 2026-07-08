class FeeQuoteModel {
  final double amount;
  final double fee;
  final double exchangeRate;
  final double receivedAmount;
  final String sourceCurrency;
  final String destinationCurrency;

  const FeeQuoteModel({
    required this.amount,
    required this.fee,
    required this.exchangeRate,
    required this.receivedAmount,
    required this.sourceCurrency,
    required this.destinationCurrency,
  });
}
