import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/configs/constants.dart';
import 'package:homesync/providers/state_providers.dart';
import 'package:homesync/services/api_service.dart';

class SmartPlugControlScreen extends ConsumerStatefulWidget {
  SmartPlugControlScreen({super.key});
  static const id = "smartplugcontrolscreen";

  @override
  ConsumerState<SmartPlugControlScreen> createState() => _SmartPlugControlScreenState();
}

class _SmartPlugControlScreenState extends ConsumerState<SmartPlugControlScreen> {
  dynamic entities;

  @override
  void initState() {
    super.initState();
  }

  // Future<void> loadEntities() async {
  //   try {
  //     final fetchedEntities = await HomeAssistantService.getEntities();
  //
  //     // Optional: print entities
  //     for (var entity in fetchedEntities) {
  //       final map = entity as Map<String, dynamic>;
  //       print("Entity ID: ${map['entity_id']}, State: ${map['state']}");
  //     }
  //
  //     setState(() {
  //       entities = fetchedEntities;
  //     });
  //   } catch (e) {
  //     print("Error fetching entities: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final entity = ref.watch(entityStateProvider((id: "switch.scw1050_socket_1", initial: null)));
    bool _isOn = entity?.state == "on";
    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text(
                    'Smart Plug',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: CustomColor.greyTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async{
                  // await HomeAssistantService.toggleDevice("switch.scw1050_socket_1");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 50),
                      content: Text(
                        _isOn ? 'Smart Plug is now ON' : 'Smart Plug is now OFF',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _isOn ? Colors.green : Colors.grey.shade400,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _isOn
                            ? Colors.green.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isOn ? Icons.power_settings_new : Icons.power_off,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _isOn ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: _isOn ? Colors.green : Colors.grey.shade600,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
