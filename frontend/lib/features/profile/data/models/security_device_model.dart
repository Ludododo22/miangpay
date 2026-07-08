class SecurityDeviceModel {
  final String id;
  final String name;
  final String location;
  final String lastActive;
  final bool current;

  const SecurityDeviceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.lastActive,
    this.current = false,
  });
}
