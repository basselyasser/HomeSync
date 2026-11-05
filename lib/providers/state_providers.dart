import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/entity_model.dart';
import '../services/socket_io_service.dart';

final entityStateProvider = StateNotifierProvider.family<EntityStateNotifier, Entity?, ({String id, Entity? initial})>(
      (ref, args) {
    final socketService = ref.watch(socketServiceProvider);
    final notifier = EntityStateNotifier(
      entityId: args.id,
      socketService: socketService,
      initialEntity: args.initial,
    );
    notifier.init();
    return notifier;
  },
);


class EntityStateNotifier extends StateNotifier<Entity?> {
  final String entityId;
  final SocketIoService socketService;

  EntityStateNotifier({
    required this.entityId,
    required this.socketService,
    Entity? initialEntity,
  }) : super(initialEntity); // Set the initial entity

  void init() {
    socketService.socket?.on('ha_event', (data) {
      try {
        if (data['event_type'] != 'state_changed') return;
        final event = data['data'];
        if (event['entity_id'] != entityId) return;

        final newState = event['new_state'];
        if (newState == null) return;

        final updated = Entity(
          id: newState['entity_id'],
          name: newState['attributes']?['friendly_name'] ?? newState['entity_id'],
          state: newState['state'],
          attributes: newState['attributes'] ?? {},
        );

        print('[EntityProvider] HA event for: ${updated.name} | New state: ${updated.state}');

        state = updated;
      } catch (e) {
        print('[EntityProvider] Failed to parse ha_event: $e');
      }
    });
  }

  @override
  void dispose() {
    socketService.socket?.off('ha_event');
    super.dispose();
  }
}

