class NotificationSettingsModel {
  final bool transactions;
  final bool security;
  final bool cards;
  final bool promotions;
  final bool loyalty;
  final bool support;
  final bool marketing;

  const NotificationSettingsModel({
    this.transactions = true,
    this.security = true,
    this.cards = true,
    this.promotions = true,
    this.loyalty = true,
    this.support = true,
    this.marketing = false,
  });
}
