import '../services/api_service.dart';
import 'entity_model.dart';

class SwitchEntity extends Entity {
  SwitchEntity({
    required String id,
    required String name,
    required String state,
    required Map<String, dynamic> attributes,
    DateTime? lastUpdated,
  }) : super(
    id: id,
    name: name,
    state: state,
    attributes: attributes,
    lastUpdated: lastUpdated,
  );

  factory SwitchEntity.fromEntity(Entity entity) {
    return SwitchEntity(
      id: entity.id,
      name: entity.name,
      state: entity.state,
      attributes: entity.attributes,
      lastUpdated: entity.lastUpdated,
    );
  }

  bool get isOn => state == 'on';

  Future<void> toggle() async {
    await HomeAssistantService().toggleSwitch(id);
  }

  Future<Entity> fetchSwitchState() async {
    final newState = await HomeAssistantService().fetchSwitchState(id);
    return copyWith(state: newState);
  }
}