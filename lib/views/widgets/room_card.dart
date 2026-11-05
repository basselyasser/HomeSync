import 'package:flutter/material.dart';
import 'package:homesync/views/screens/devices_screen.dart';

import '../../models/room_model.dart';


class RoomCard extends StatefulWidget {
  final Room room;

  const RoomCard({
    super.key,
    required this.room,
  });

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool isOn = false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, DevicePage.id, arguments: {'isAllDevicesScreen': false});
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFC3CFC6),
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/livingRoom.png'),
            fit: BoxFit.none,
            scale: 0.9,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            // Room name and device count
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.room.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),

            // ON/OFF text and switch
            // Positioned(
            //   right: 16,
            //   bottom: 10,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Text(
            //         isOn ? 'ON' : 'OFF',
            //         style: const TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       const SizedBox(width: 30),
            //       SizedBox(
            //         height: 20,
            //         child: Transform.scale(
            //           scale: 0.8,
            //           child: Switch(
            //             value: isOn,
            //             onChanged: (value) {
            //               setState(() {
            //                 isOn = value;
            //               });
            //             },
            //             activeColor: Colors.white,
            //             activeTrackColor: const Color(0xFF6B9080),
            //             inactiveThumbColor: const Color(0xFFA5B79F),
            //             inactiveTrackColor: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}


 