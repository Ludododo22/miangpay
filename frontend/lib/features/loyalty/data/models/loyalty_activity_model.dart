class LoyaltyActivityModel {
  final String id;
  final String title;
  final String source;
  final int points;
  final DateTime date;

  const LoyaltyActivityModel({
    required this.id,
    required this.title,
    required this.source,
    required this.points,
    required this.date,
  });
}
