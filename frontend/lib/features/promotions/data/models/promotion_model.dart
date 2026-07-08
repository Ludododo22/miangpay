class PromotionModel {
  final String id;
  final String title;
  final String description;
  final String tag;
  final String category;
  final String corridor;
  final String expiresAt;
  final int remainingUses;
  final bool isFeatured;

  const PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.category,
    required this.corridor,
    required this.expiresAt,
    required this.remainingUses,
    this.isFeatured = false,
  });
}
