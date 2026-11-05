import 'package:flutter/material.dart';
import 'package:homesync/views/screens/rooms_screen.dart';
import 'package:homesync/views/widgets/switch_entity_card.dart';
import '../../configs/constants.dart';
import '../../models/room_model.dart';

class DevicePage extends StatelessWidget {
  static const id = "DeviceScreen";

  final List<Room> devices = [
    Room(id: 'e', name: 'Lamp', icon: 'lamp.png', deviceIds: ['dev1']),
    Room(id: 'e2',name: 'AC', icon: 'AirCond.png', deviceIds: ['dev2']),
    Room(id: 'e3',name: 'TV', icon: 'TV.png', deviceIds: ['dev3']),
    Room(id: 'e4',name: 'Lamp Bedroom', icon: 'lamp.png', deviceIds: ['dev4']),
  ];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map?;
    final bool isAllDevicesScreen = arguments?['isAllDevicesScreen'] ?? true;

    return Scaffold(
      appBar: isAllDevicesScreen == true ? AppBar(
        title: const Text('All Devices',
            style: TextStyle(
              color: CustomColor.greyTextColor,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: CustomColor.backgroundColor,
        elevation: 0,
      ) :  AppBar(
        title: const Text('Room Devices',
            style: TextStyle(
              color: CustomColor.greyTextColor,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: CustomColor.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            // const Text('Your Devices',
            //     style: TextStyle(
            //       color: CustomColor.greenTitle,
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold,
            //     )),
            const SizedBox(height: 20),

            // Grid Layout
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomCard({
    required String icon,
    required String name,
    required bool isActive,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColor.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(icon, width: 200, height: 51),
            const SizedBox(height: 16),
            Text(name,
                style: const TextStyle(
                  color: CustomColor.greenTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 4),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isActive ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: isActive
                          ? CustomColor.greyTextColor
                          : CustomColor.greyTextColor,
                      fontWeight: FontWeight.bold,
                    )),
                Switch(
                  value: isActive,
                  activeColor: CustomColor.greenTitle,
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
