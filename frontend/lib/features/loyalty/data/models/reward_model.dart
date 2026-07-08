class RewardModel {
  final String id;
  final String title;
  final String description;
  final int pointsCost;
  final String category;
  final bool available;

  const RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsCost,
    required this.category,
    this.available = true,
  });
}
