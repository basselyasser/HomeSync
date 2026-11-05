// socket_io_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketServiceProvider = Provider<SocketIoService>((ref) {
  throw UnimplementedError(); // Will be overridden in main.dart
});

class SocketIoService {
  final String serverUrl;
  IO.Socket? socket;

  SocketIoService({required this.serverUrl});

  void connect() {
    socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('[SOCKET] ✅ Connected to $serverUrl');
    });

    socket!.onDisconnect((_) {
      print('[SOCKET] ❌ Disconnected');
    });

    socket!.onError((data) {
      print('[SOCKET] 🔥 Error: $data');
    });

    // 🎯 Handle specific ha_event logic
    socket!.on('ha_event', (data) {
      final eventType = data['event_type'];
      final eventData = data['data'];

      if(eventType == 'state_changed'){
        print('[SOCKET] 🔄 State Changed: ${eventData['entity_id']}');
      }

    });
  }
}
