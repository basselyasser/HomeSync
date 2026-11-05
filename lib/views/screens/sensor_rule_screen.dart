import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/configs/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/entity_model.dart';
import '../../providers/state_providers.dart';

class SensorRuleScreen extends ConsumerStatefulWidget {
  final Entity? entity;
  const SensorRuleScreen({super.key, this.entity});
  static const id = "sensorrulescreen";

  @override
  ConsumerState<SensorRuleScreen> createState() => _SensorRuleScreenState();
}

class _SensorRuleScreenState extends ConsumerState<SensorRuleScreen> {
  late String sensorType;
  late double ruleValue;
  late double _sliderValue;
  bool _isLoading = false;
  bool _sliderInitialized = false;
  bool isAutomationEnabled = true;

  @override
  void initState() {
    super.initState();
    _initRuleValue();
  }

  Future<void> _initRuleValue() async {
    try {
      sensorType = _getSensorType(widget.entity!.id);

      // Default value
      final min = _getMinValue();
      final max = _getMaxValue();
      ruleValue = (min + max) / 2;

      final res = await http.get(Uri.parse('http://192.168.151.76:5000/rules/'));

      if (res.statusCode == 200) {
        final rules = json.decode(res.body) as List;
        final matchingRule = rules.firstWhere(
              (r) => r['sensor_type'] == sensorType,
          orElse: () => null,
        );

        if (matchingRule != null) {
          ruleValue = (matchingRule['threshold'] as num).toDouble();
          isAutomationEnabled = matchingRule['is_enabled'];
        }
      }
    } catch (e) {
      debugPrint('Error fetching rule: $e');
    }
  }

  String _getSensorType(String id) {
    if (id.contains('temperature')) return 'temperature';
    if (id.contains('humidity')) return 'humidity';
    if (id.contains('smoke')) return 'smoke';
    if (id.contains('light')) return 'light';
    return 'unknown';
  }

  Future<void> _saveRule({required bool enableAutomation}) async {
    try {
      final actionDeviceMap = {
        "smoke": "switch.esphome_web_73dcbc_buzzer",
        "light": "switch.esphome_web_73dcbc_led",
        "temperature": "switch.esphome_web_73dcbc_fan",
      };

      final body = {
        "sensor_type": sensorType,
        "threshold": enableAutomation
            ? _sliderValue
            : (sensorType == 'smoke' ? 9999 : -9999),
        "is_enabled": enableAutomation,
        "action_device_id": actionDeviceMap[sensorType] ?? "switch.default",
      };

      final res = await http.post(
        Uri.parse("http://192.168.151.76:5000/rules/"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body
        ),
      );

      if (res.statusCode == 200) {
        setState(() {
          ruleValue = enableAutomation ? _sliderValue : -999;
          isAutomationEnabled = enableAutomation;
        });
      } else {
        debugPrint("Failed to save rule: ${res.body}");
      }
    } catch (e) {
      debugPrint("Error saving rule: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveEntity = ref.watch(entityStateProvider((id: widget.entity!.id, initial: widget.entity)));
    final sensorValue = double.tryParse(liveEntity?.state ?? '') ?? 0.0;

    if (!_sliderInitialized && !_isLoading) {
      _sliderValue = ruleValue == -999 ? sensorValue : ruleValue;
      _sliderInitialized = true;
    }

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
                      widget.entity?.name ?? "Sensor",
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
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                const Text(
                  'Value',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.greyTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _sliderValue,
                  min: _getMinValue(),
                  max: _getMaxValue(),
                  divisions: _getDivisions(),
                  label: '${_sliderValue.round()}',
                  onChanged: (value) => setState(() => _sliderValue = value),
                  activeColor: CustomColor.buttonBackgroundColor,
                  inactiveColor: Colors.grey.shade300,
                ),
                Center(
                  child: Text(
                    '${_sliderValue.toInt()}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: CustomColor.greyTextColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveRule(enableAutomation: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.buttonBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveRule(enableAutomation: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.buttonBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Turn off automation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Text(
                      '${sensorValue.toStringAsFixed(1)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.greyTextColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: !isAutomationEnabled || ruleValue == -999
                        ? const Text(
                      'No automation for this device',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.greyTextColor,
                      ),
                    )
                        : Text(
                      'Rule applies when above $ruleValue',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: CustomColor.greyTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double _getMinValue() {
    if (widget.entity!.id.contains('temperature')) return -10.0;
    if (widget.entity!.id.contains('humidity')) return 0.0;
    if (widget.entity!.id.contains('smoke')) return 500.0;
    if (widget.entity!.id.contains('light')) return 2000.0;
    return 0.0;
  }

  double _getMaxValue() {
    if (widget.entity!.id.contains('temperature')) return 50.0;
    if (widget.entity!.id.contains('humidity')) return 100.0;
    if (widget.entity!.id.contains('smoke')) return 5000.0;
    if (widget.entity!.id.contains('light')) return 8000.0;
    return 100.0;
  }

  int _getDivisions() {
    if (widget.entity!.id.contains('temperature')) return 60;
    if (widget.entity!.id.contains('humidity')) return 100;
    if (widget.entity!.id.contains('smoke')) return 45;
    if (widget.entity!.id.contains('light')) return 120;
    return 10;
  }
}
