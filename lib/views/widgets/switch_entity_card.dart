import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/providers/state_providers.dart';
import 'package:homesync/views/screens/switch_screen.dart';
import '../../models/switch_entity_model.dart';

class SwitchCard extends ConsumerStatefulWidget {
  final SwitchEntity entity;

  const SwitchCard({
    super.key,
    required this.entity,
  });

  @override
  _SwitchCardState createState() => _SwitchCardState();
}

class _SwitchCardState extends ConsumerState<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    final entity = ref.watch(entityStateProvider((id: widget.entity.id, initial: widget.entity)));

    if (entity == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final isOn = entity.state == "on";
    late IconData sensorIcon;

    if (widget.entity.id.contains('led')) {
      sensorIcon = Icons.lightbulb;
    } else if (widget.entity.id.contains('buzzer')) {
      sensorIcon = Icons.noise_aware;
    } else if (widget.entity.id.contains('fan')) {
      sensorIcon = Icons.mode_fan_off;
    } else {
      sensorIcon = Icons.power; // fallback icon
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SwitchScreen(entity: widget.entity)),
        );
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFC3CFC6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: 0,
              bottom: 80,
              child: Center(
                child: Icon(
                  sensorIcon,
                  size: 50,
                  color: Colors.black54,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 45,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.entity.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entity.state,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 10,
              child: SizedBox(
                height: 20,
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isOn,
                    onChanged: (value) async {
                      await widget.entity.toggle();
                    },
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF6B9080),
                    inactiveThumbColor: const Color(0xFFA5B79F),
                    inactiveTrackColor: Colors.white,
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
