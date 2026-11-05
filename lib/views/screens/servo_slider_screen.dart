import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/configs/constants.dart';
import 'package:homesync/models/entity_model.dart';
import 'package:homesync/providers/state_providers.dart';
import 'package:homesync/services/api_service.dart';

class ServoSliderScreen extends ConsumerStatefulWidget {
  final Entity entity;
  const ServoSliderScreen({super.key, required this.entity});
  static const id = "servosliderscreen";

  @override
  ConsumerState<ServoSliderScreen> createState() => _ServoSliderScreenState();
}

class _ServoSliderScreenState extends ConsumerState<ServoSliderScreen> {
  double _currentValue = 0.0;
  bool _isLoading = true;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Servo set to ${value.toStringAsFixed(1)}'),
          duration: const Duration(milliseconds: 500),
        ),
      );
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
    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.entity.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: CustomColor.greyTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Servo Position',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.greyTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _currentValue,
                    min: -100,
                    max: 100,
                    divisions: 200,
                    label: _currentValue.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _currentValue = value);
                    },
                    onChangeEnd: _updateServoPosition,
                    activeColor: CustomColor.buttonBackgroundColor,
                    inactiveColor: Colors.grey.shade300,
                  ),
                  Center(
                    child: Text(
                      '${_currentValue.toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: CustomColor.greyTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateServoPosition(-100),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.buttonBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Min',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateServoPosition(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.buttonBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Center',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _updateServoPosition(100),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColor.buttonBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Max',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
