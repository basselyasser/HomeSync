import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/models/entity_model.dart';
import 'package:homesync/views/screens/servo_slider_screen.dart';
import '../../providers/state_providers.dart';
import '../../services/api_service.dart';

class ServoSliderCard extends ConsumerStatefulWidget {
  final Entity entity;

  const ServoSliderCard({
    super.key,
    required this.entity,
  });

  @override
  _ServoSliderCardState createState() => _ServoSliderCardState();
}

class _ServoSliderCardState extends ConsumerState<ServoSliderCard> {
  double _currentValue = 0.0; // Default center position (0)
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentValue();
  }

  Future<void> _loadCurrentValue() async {
    setState(() => _isLoading = true);
    try {
      final value = await HomeAssistantService().getServoValue(widget.entity.id);
      setState(() => _currentValue = value);
    } catch (e) {
      debugPrint('Error loading servo value: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateServoPosition(double value) async {
    setState(() {
      _currentValue = value;
      _isLoading = true;
    });

    try {
      await HomeAssistantService().setServoValue(widget.entity.id, value);
    } catch (e) {
      debugPrint('Error updating servo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update servo: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // String numberValue = ref.watch(entityStateProvider(widget.entity.id)) ?? '';

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ServoSliderScreen(entity: widget.entity)),
        );
      }
      ,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFC3CFC6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Title
            const Positioned.fill(
              top: 0,
              bottom: 150,
              child: Center(
                child: Icon(
                  Icons.settings_input_component,
                  size: 50,
                  color: Colors.black54,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 100,
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
                ],
              ),
            ),

            // Current Value Display
            Positioned(
              left: 45,
              bottom: 70,
              child: Text(
                _currentValue.toStringAsFixed(1), // Show 1 decimal place
                style: const TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Slider(
                        value: _currentValue,
                        min: -100,
                        max: 100,
                        divisions: 200, // Gives 1 unit steps
                        label: _currentValue.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() => _currentValue = value);
                        },
                        onChangeEnd: _updateServoPosition,
                        activeColor: const Color(0xFF6B9080),
                        inactiveColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading indicator
            if (_isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}