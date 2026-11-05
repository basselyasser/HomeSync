import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/entity_model.dart';
import '../models/room_model.dart';
import '../models/switch_entity_model.dart';
import '../view_models/entity_view_model.dart';

final homeDataProvider = FutureProvider.autoDispose<HomeData>((ref) async {
  final viewModel = EntityViewModel();
  final switchEntities = await viewModel.fetchSwitchEntities();
  final sensorEntities = await viewModel.fetchSensorEntities();
  final numberEntities = await viewModel.fetchNumberEntities();
  final rooms = await viewModel.fetchRooms();

  return HomeData(
    switchEntities: switchEntities,
    sensorEntities: sensorEntities,
    numberEntities: numberEntities,
    rooms: rooms,
  );
});

class HomeData {
  final List<SwitchEntity> switchEntities;
  final List<Entity> sensorEntities;
  final List<Entity> numberEntities;
  final List<Room> rooms;

  HomeData({
    required this.switchEntities,
    required this.sensorEntities,
    required this.numberEntities,
    required this.rooms,
  });
}