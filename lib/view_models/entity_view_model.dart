import 'package:flutter/material.dart';
import 'package:homesync/services/api_service.dart';
import '../models/entity_model.dart';
import '../models/room_model.dart';
import '../models/switch_entity_model.dart';

class EntityViewModel extends ChangeNotifier {
  HomeAssistantService HAService = HomeAssistantService();

  Future<void> init() async {
    try {
      List<Entity> entities = await HAService.fetchSwitchEntities();
      for (var entity in entities) {
        print('Entity ID: ${entity.id}, Name: ${entity.name}, State: ${entity.state}');
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching entities: $e');
    }

    final switchState = await HAService.fetchSwitchState("switch.scw1050_socket_1");
    print("SCW1050 State = $switchState");
  }

  Future<List<Room>> fetchRooms() async{
    try {
      List<Room> rooms = await HAService.fetchRooms();
      return rooms;
    } catch (e) {
      print('Error fetching rooms: $e');
      return []; // Return an empty list on error
    }
  }

  Future<List<SwitchEntity>> fetchSwitchEntities() async {
    try {
      List<SwitchEntity> entities = await HAService.fetchSwitchEntities();
      for (var entity in entities) {
        print('Entity ID: ${entity.id}, Name: ${entity.name}, State: ${entity.state}');
        HomeAssistantService().createDevice(entity.id, entity.name, "switch");
      }

      return entities;
    } catch (e) {
      print('Error fetching entities: $e');
      return []; // Return an empty list on error
    }
  }

  Future<List<Entity>> fetchSensorEntities() async {
    try {
      List<Entity> entities = await HAService.fetchSensorEntities();
      for (var entity in entities) {
        print('Entity ID: ${entity.id}, Name: ${entity.name}, State: ${entity.state}');
        HomeAssistantService().createDevice(entity.id, entity.name, "sensor");

      }

      return entities;
    } catch (e) {
      print('Error fetching entities: $e');
      return []; // Return an empty list on error
    }
  }

  Future<List<Entity>> fetchNumberEntities() async {
    try {
      List<Entity> entities = await HAService.fetchNumberEntities();
      for (var entity in entities) {
        print('Entity ID: ${entity.id}, Name: ${entity.name}, State: ${entity.state}');
        HomeAssistantService().createDevice(entity.id, entity.name, "number");

      }
      return entities;
    } catch (e) {
      print('Error fetching entities: $e');
      return []; // Return an empty list on error
    }
  }

}
