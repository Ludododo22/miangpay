class LoyaltyChallengeModel {
  final String id;
  final String title;
  final String description;
  final int rewardPoints;
  final int progress;
  final int target;
  final String deadline;

  const LoyaltyChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardPoints,
    required this.progress,
    required this.target,
    required this.deadline,
  });

  double get ratio => target == 0 ? 0 : progress / target;
}
