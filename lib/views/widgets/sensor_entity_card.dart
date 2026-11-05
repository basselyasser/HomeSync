import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/views/screens/sensor_rule_screen.dart';
import '../../models/entity_model.dart';
import '../../providers/state_providers.dart';

class SensorCard extends ConsumerWidget {
  final Entity sensorEntity;

  const SensorCard({
    super.key,
    required this.sensorEntity,
  });

  ({String level, Color color, String displayText}) _getLightLevelInfo(double value) {
    if (value <= 3500) {
      return (level: 'Bright', color: Colors.yellow[700]!, displayText: 'Bright');
    } else {
      return (level: 'Dark', color: Colors.blueGrey, displayText: 'Dark');
    }
  }



  // Helper function to determine smoke level, color, and display text
  ({String level, Color color, String displayText}) _getSmokeLevelInfo(double value) {
    if (value <= 2500) {
      return (level: 'Low', color: Colors.green, displayText: 'Low');
    } else if (value <= 3800) {
      return (level: 'Medium', color: Colors.orange, displayText: 'Medium');
    } else {
      return (level: 'High', color: Colors.red, displayText: 'High');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorData = ref.watch(entityStateProvider((id: sensorEntity.id, initial: sensorEntity)));

    // Handle null case
    if (sensorData == null) {
      return const CircularProgressIndicator(); // or some placeholder
    }

    // Get the state and attributes from the Entity object
    final sensorValue = sensorData.state;

    late IconData sensorIcon;
    Color? statusColor;
    String displayText = sensorValue; // Default to raw value

    // Parse sensor value to double (handle non-numeric cases)
    final numericValue = double.tryParse(sensorValue);

    // Set icon and apply smoke thresholds if this is a smoke sensor
// Handle motion sensor explicitly
    if (sensorEntity.id.contains('motion')) {
      sensorIcon = Icons.directions_walk;
      if (sensorValue == 'on') {
        displayText = 'Motion Detected';
        statusColor = Colors.red;
      } else if (sensorValue == 'off') {
        displayText = 'No Motion';
        statusColor = Colors.green;
      } else {
        displayText = 'Unknown';
        statusColor = Colors.grey;
      }
    } else {
      // For sensors with numeric values
      final numericValue = double.tryParse(sensorValue);

      if (sensorEntity.id.contains('temperature')) {
        sensorIcon = Icons.thermostat;
      } else if (sensorEntity.id.contains('humidity')) {
        sensorIcon = Icons.percent;
      } else if (sensorEntity.id.contains('smoke')) {
        sensorIcon = Icons.smoke_free;
        if (numericValue != null) {
          final info = _getSmokeLevelInfo(numericValue);
          statusColor = info.color;
          displayText = info.displayText;
        }
      } else if (sensorEntity.id.contains('light')) {
        sensorIcon = Icons.light_mode;
        if (numericValue != null) {
          final info = _getLightLevelInfo(numericValue);
          statusColor = info.color;
          displayText = info.displayText;
        }
      }
      else if (sensorEntity.id.contains('current')) {
        sensorIcon = Icons.electrical_services;
      } else {
        sensorIcon = Icons.sensors;
      }
    }

    return GestureDetector(
      onTap: () {
        if (!sensorEntity.id.contains("motion") && !sensorEntity.id.contains("current")) {
          print("THE ID IS ${sensorEntity.id}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SensorRuleScreen(entity: sensorEntity),
            ),
          );
        }
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: statusColor?.withOpacity(0.3) ?? const Color(0xFFC3CFC6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: statusColor ?? Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: 0,
              bottom: 150,
              child: Center(
                child: Icon(
                  sensorIcon,
                  size: 50,
                  color: statusColor ?? Colors.black54,
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
                    sensorEntity.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayText, // Use the computed display text
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: statusColor ?? Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}