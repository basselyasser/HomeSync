class Room {
  final String id;
  final String name;
  final String? icon;
  final List<String> deviceIds;
  final bool? isOn;

  Room({
    required this.id,
    required this.name,
    this.icon,
    required this.deviceIds,
    this.isOn,
  });

  factory Room.fromApi(Map<String, dynamic> json) {
    return Room(
      id: json['room_id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?, // Will be null if not provided
      deviceIds: (json['devices'] as List<dynamic>?)?.cast<String>() ?? [],
      isOn: json['is_on'] as bool? ?? false,
    );
  }
}
