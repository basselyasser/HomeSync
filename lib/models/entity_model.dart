import 'package:flutter_riverpod/flutter_riverpod.dart';

class Entity {
  final String id;
  final String name;
  final String state;
  final Map<String, dynamic> attributes;
  final DateTime lastUpdated;

  Entity({
    required this.id,
    required this.name,
    required this.state,
    required this.attributes,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      id: json['entity_id'],
      name: json['attributes']['friendly_name'] ?? '',
      state: json['state'],
      attributes: json['attributes'] ?? {},
    );
  }

  Entity copyWith({
    String? id,
    String? name,
    String? state,
    Map<String, dynamic>? attributes,
    DateTime? lastUpdated,
  }) {
    return Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      attributes: attributes ?? this.attributes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Entity withCleanedName() {
    return copyWith(
      name: name.replaceAll('ESPHome Web 73dcbc', '').trim(),
    );
  }
}