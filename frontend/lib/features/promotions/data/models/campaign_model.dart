class CampaignModel {
  final String id;
  final String title;
  final String description;
  final int progress;
  final String reward;
  final String timeLeft;

  const CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.reward,
    required this.timeLeft,
  });
}
