import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/providers/state_providers.dart';
import 'package:homesync/services/api_service.dart';

import '../../models/entity_model.dart';
import '../../models/switch_entity_model.dart';

class SwitchScreen extends ConsumerStatefulWidget {
  final SwitchEntity entity;

  const SwitchScreen({
    super.key,
    required this.entity,
  });

  static const id = "smartplugcontrolscreen";

  @override
  ConsumerState<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends ConsumerState<SwitchScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(entityStateProvider((id: widget.entity.id, initial: widget.entity)));
    final isOn = (state?.state.toLowerCase() ?? "off") == "on";

    return Scaffold(
      backgroundColor: const Color(0xFFC3CFC6),
      body: SafeArea(
        child: Column(
          children: [
            // Back button and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.entity.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon(Icons.lightbulb, size: 60,),
                          // const SizedBox(height: 30),

                          // ON/OFF text and switch
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isOn ? 'ON' : 'OFF',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Switch(
                                value: isOn == true,
                                onChanged: (value) async {
                                  await widget.entity.toggle();
                                },
                                activeColor: Colors.white,
                                activeTrackColor: const Color(0xFF6B9080),
                                inactiveThumbColor: const Color(0xFFA5B79F),
                                inactiveTrackColor: const Color(0xFFE0E0E0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}