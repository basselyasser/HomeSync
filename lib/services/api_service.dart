import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/entity_model.dart';
import '../models/room_model.dart';
import '../models/switch_entity_model.dart';
import '../models/user_model.dart';

class HomeAssistantService {
  static const String _token = 'YOUR_HOME_ASSISTANT_TOKEN';

  // Configuration to switch between direct HA access and backend server
  static bool _useBackendServer = true;
  static String _backendServerIp = '192.168.151.76'; // Default backend server IP
  static int _backendServerPort = 5000; // Default backend server port

  static Future<void> configure({bool useBackendServer = false, String? backendServerIp, int? backendServerPort}) async {
    _useBackendServer = useBackendServer;
    if (backendServerIp != null) _backendServerIp = backendServerIp;
    if (backendServerPort != null) _backendServerPort = backendServerPort;

    // You can also save these settings to SharedPreferences if needed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_backend_server', _useBackendServer);
    if (backendServerIp != null) await prefs.setString('backend_server_ip', _backendServerIp);
    if (backendServerPort != null) await prefs.setInt('backend_server_port', _backendServerPort);
  }

  static Future<String> getBaseUrl() async {
    if (_useBackendServer) {
      return 'http://$_backendServerIp:$_backendServerPort';
    } else {
      final prefs = await SharedPreferences.getInstance();
      final ip = prefs.getString('home_assistant_ip') ?? '192.168.1.2';
      return 'http://$ip:8123/api';
    }
  }

  Future<List<SwitchEntity>> fetchSwitchEntities() async {
    final baseUrl = await getBaseUrl();
    print("Getting switch entities with url $baseUrl");

    if (_useBackendServer) {
      final response = await http.get(
        Uri.parse('$baseUrl/switches'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonList = jsonDecode(response.body);
        List<Entity> allEntities = jsonList.map((json) {
          final entity = Entity.fromJson(json);
          return _cleanEntityName(entity); // Clean the name
        }).toList();

        List<Entity> filteredEntities = allEntities
            .where((entity) =>
        entity.id.startsWith('switch.') &&
            !entity.id.contains('child') &&
            entity.state != 'unavailable')
            .toList();

        return filteredEntities
            .map((entity) => SwitchEntity.fromEntity(entity))
            .toList();
      } else {
        throw Exception('Failed to load switch entities from backend');
      }
    } else {
      final response = await http.get(
        Uri.parse('$baseUrl/states'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonList = jsonDecode(response.body);
        List<Entity> allEntities = jsonList.map((json) {
          final entity = Entity.fromJson(json);
          return _cleanEntityName(entity); // Clean the name
        }).toList();

        List<Entity> filteredEntities = allEntities
            .where((entity) =>
        entity.id.startsWith('switch.') &&
            !entity.id.contains('child') &&
            entity.state != 'unavailable')
            .toList();

        return filteredEntities
            .map((entity) => SwitchEntity.fromEntity(entity))
            .toList();
      } else {
        throw Exception('Failed to load entities');
      }
    }
  }

  Future<List<Entity>> fetchNumberEntities() async {
    try {
      final baseUrl = await getBaseUrl();

      if (_useBackendServer) {
        final response = await http.get(
          Uri.parse('$baseUrl/numbers'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          List jsonList = jsonDecode(response.body);
          List<Entity> allEntities = jsonList.map((json) {
            final entity = Entity.fromJson(json);
            return _cleanEntityName(entity); // Clean the name
          }).toList();

          List<Entity> numberEntities = allEntities
              .where((entity) =>
          entity.id.startsWith('number.') &&
              !entity.id.contains('child') &&
              entity.state != 'unavailable')
              .toList();

          for (var entity in numberEntities) {
            print('Number Entity ID: ${entity.id}, Name: ${entity.name}, State: ${entity.state}');
          }

          return numberEntities;
        } else {
          throw Exception('Failed to load number entities from backend: ${response.statusCode}');
        }
      } else {
        final response = await http.get(
          Uri.parse('$baseUrl/states'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          List jsonList = jsonDecode(response.body);
          List<Entity> allEntities = jsonList.map((json) {
            final entity = Entity.fromJson(json);
            return _cleanEntityName(entity); // Clean the name
          }).toList();

          List<Entity> numberEntities = allEntities
              .where((entity) =>
          entity.id.startsWith('number.') &&
              !entity.id.contains('child') &&
              entity.state != 'unavailable')
              .toList();

          for (var entity in numberEntities) {
            print('Number Entity ID: ${entity.id}, Name: ${entity.name}, State: ${entity.state}');
          }

          return numberEntities;
        } else {
          throw Exception('Failed to load entities: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching number entities: $e');
      return [];
    }
  }

  Future<List<Entity>> fetchSensorEntities() async {
    final baseUrl = await getBaseUrl();
    print("Getting sensor entities with url $baseUrl");

    if (_useBackendServer) {
      final response = await http.get(
        Uri.parse('$baseUrl/sensors'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonList = jsonDecode(response.body);
        List<Entity> allEntities = jsonList.map((json) {
          final entity = Entity.fromJson(json);
          return _cleanEntityName(entity); // Clean the name
        }).toList();

        List<Entity> filteredSensors = allEntities
            .where((entity) =>
        (entity.id.startsWith('sensor.') ||
            entity.id.startsWith('binary_sensor.')) &&
            entity.id.contains('esphome') &&
            !entity.id.contains('child') &&
            entity.state != 'unavailable')
            .toList();
        return filteredSensors;
      } else {
        throw Exception('Failed to load sensor entities from backend');
      }
    } else {
      final response = await http.get(
        Uri.parse('$baseUrl/states'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List jsonList = jsonDecode(response.body);
        List<Entity> allEntities = jsonList.map((json) {
          final entity = Entity.fromJson(json);
          return _cleanEntityName(entity); // Clean the name
        }).toList();

        List<Entity> filteredSensors = allEntities
            .where((entity) =>
        (entity.id.startsWith('sensor.') ||
            entity.id.startsWith('binary_sensor.')) &&
            entity.id.contains('esphome') &&
            !entity.id.contains('child') &&
            entity.state != 'unavailable')
            .toList();
        return filteredSensors;
      } else {
        throw Exception('Failed to load sensor entities');
      }
    }
  }

// Helper function to clean entity names
  Entity _cleanEntityName(Entity entity) {
    if (entity.name != null) {
      // Remove "ESPHome Web 73dcbc" and any trailing whitespace
      final cleanedName = entity.name!.replaceAll('ESPHome Web 73dcbc', '').trim();
      return entity.copyWith(name: cleanedName);
    }
    return entity;
  }

  Future<List<Room>> fetchRooms() async {
    final baseUrl = await getBaseUrl();
    final currentUser = FirebaseAuth.instance.currentUser; // Get current user

    // Check if user is authenticated
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }
    final uid = currentUser.uid; // Get UID

    final response = await http.get(
      Uri.parse('$baseUrl/rooms/list/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded
            .where((roomJson) => roomJson is Map<String, dynamic> && roomJson['user'] == uid) // Filter by UID
            .map((roomJson) => Room.fromApi(roomJson))
            .toList();
      } else {
        throw Exception('Unexpected data format: expected a list');
      }
    } else {
      throw Exception('Failed to fetch rooms: ${response.statusCode}');
    }
  }
  Future<void> toggleSwitch(String id, {bool? turnOn}) async {
    final baseUrl = await getBaseUrl();

    if (_useBackendServer) {
      // Call to backend server endpoint for toggle
      final response = await http.post(
        Uri.parse('$baseUrl/switches/toggle/'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'entity_id': id,
          'turn_on': turnOn,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle switch via backend');
      }
    } else {
      // Original Home Assistant direct call
      String service;

      if (turnOn != null) {
        service = turnOn ? 'turn_on' : 'turn_off';
      } else {
        final currentState = await fetchSwitchState(id);
        if (currentState == 'on') {
          service = 'turn_off';
        } else if (currentState == 'off') {
          service = 'turn_on';
        } else {
          throw Exception('Invalid switch state: $currentState');
        }
      }

      final response = await http.post(
        Uri.parse('$baseUrl/services/switch/$service'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'entity_id': id,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle switch');
      }
    }
  }

  Future<String> fetchSwitchState(String id) async {
    final baseUrl = await getBaseUrl();

    if (_useBackendServer) {
      // Call to backend server endpoint for switch state
      final response = await http.get(
        Uri.parse('$baseUrl/switches/$id/state'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['state'] ?? 'unknown';
      } else {
        throw Exception('Failed to fetch state from backend for $id');
      }
    } else {
      // Original Home Assistant direct call
      final response = await http.get(
        Uri.parse('$baseUrl/states/$id'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['state'] ?? 'unknown';
      } else {
        throw Exception('Failed to fetch state for $id');
      }
    }
  }

  Future<void> setServoValue(String entityId, double value) async {
    final baseUrl = await getBaseUrl();

    if (_useBackendServer) {
      // Call to backend server endpoint for setting number value
      final response = await http.post(
        Uri.parse('$baseUrl/numbers/set/'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'entity_id': entityId,
          'value': value,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set number value via backend: ${response.body}');
      }
    } else {
      // Original Home Assistant direct call
      final response = await http.post(
        Uri.parse('$baseUrl/services/number/set_value'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'entity_id': entityId,
          'value': value,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to set number value: ${response.body}');
      }
    }
  }

  Future<AppUser?> fetchUserByUid(String uid) async {
    final baseUrl = await getBaseUrl();

    final url = Uri.parse('$baseUrl/users/get_username/$uid');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AppUser(
          username: data['username'],
          email: data['email'],
          uid: data['uid'],
          createdAt: DateTime.parse(data['created_at']),
        );
      } else {
        print('User fetch failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchWeatherData() async {
    final baseUrl = await await getBaseUrl();

    try {
      final response = await http.get(Uri.parse('$baseUrl/weather'));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print("Weather API error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }


  Future<double> getServoValue(String entityId) async {
    final baseUrl = await getBaseUrl();

    if (_useBackendServer) {
      // Call to backend server endpoint for getting number value
      final response = await http.get(
        Uri.parse('$baseUrl/numbers/'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          final servo = data.firstWhere(
                (item) => item['entity_id'] == entityId,
            orElse: () => null,
          );

          if (servo == null) {
            throw Exception('Entity $entityId not found in list');
          }

          return double.tryParse(servo['state']?.toString() ?? '0') ?? 0;
        } else {
          throw Exception('Unexpected response format: not a list');
        }
      } else {
        throw Exception('Failed to get number value via backend: ${response.body}');
      }
    } else {
      // Original Home Assistant direct call
      final response = await http.get(
        Uri.parse('$baseUrl/states/$entityId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return double.tryParse(json['state']?.toString() ?? '0') ?? 0;
      } else {
        throw Exception('Failed to get number value: ${response.body}');
      }
    }
  }

  Future<void> createUser(String username, String email, String uid)async{
    final baseUrl = await getBaseUrl();
    final response = await http.post(

      Uri.parse('$baseUrl/users/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'uid': uid,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to set number value via backend: ${response.body}');
    }
  }

  Future<void> createDevice(String deviceId, String deviceName, String type) async {
    final baseUrl = await getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/devices/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'device_id': deviceId,
        'device_name': deviceName,
        'type': type,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create device: ${response.body}');
    }
    // Optionally parse the response to get device ID
    final responseData = jsonDecode(response.body);
    print('Device created/exists: ${responseData['id']}');
  }

  Future<void> createRoom (String roomId, String roomName, String userId) async{
    final baseUrl = await getBaseUrl();

    final response = await http.post(
      Uri.parse('$baseUrl/rooms/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'room_id': roomId,
        'name': roomName,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to set number value via backend: ${response.body}');
    }
  }


}