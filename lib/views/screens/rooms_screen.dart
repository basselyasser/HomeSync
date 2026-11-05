import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homesync/services/api_service.dart';
import 'package:homesync/views/widgets/room_card.dart';
import '../../configs/constants.dart';
import '../../models/room_model.dart';

class RoomsPage extends StatefulWidget {
  static const id = "RoomScreen";

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final List<Room> rooms = [

  ];

  final TextEditingController _roomNameController = TextEditingController();
  final HomeAssistantService _apiService = HomeAssistantService();

  Future<void> _createNewRoom() async {
    final String roomName = _roomNameController.text.trim();
    if (roomName.isEmpty) return;

    try {
      // Generate a unique ID - you might want to use UUID in production
      final String roomId = 'room_${DateTime.now().millisecondsSinceEpoch}';

      // Replace 'current_user_id' with your actual user ID retrieval logic
      await _apiService.createRoom(roomId, roomName, "uid 1");

      _roomNameController.clear();
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create room: $e')),
      );
    }
  }

  void _showCreateRoomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Create New Room',
            style: TextStyle(color: CustomColor.greenTitle),
          ),
          content: TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(
              labelText: 'Room Name',
              hintText: 'e.g., Living Room',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: CustomColor.greyTextColor),
              ),
            ),
            TextButton(
              onPressed: _createNewRoom,
              child: const Text(
                'Save',
                style: TextStyle(color: CustomColor.greenTitle),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Rooms', style: TextStyle(
          color: CustomColor.greyTextColor,
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: CustomColor.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: CustomColor.greenTitle),
            onPressed: _showCreateRoomDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: rooms.map((room) => RoomCard(room: room)).toList(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: "bottomLeftCreateButton", // Unique tag if using multiple FABs
              onPressed: _showCreateRoomDialog,
              backgroundColor: CustomColor.greenTitle,
              mini: true,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }
}