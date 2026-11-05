import 'package:flutter/material.dart';
import 'package:homesync/configs/constants.dart';

class AirConditionerControlScreen extends StatelessWidget {
  AirConditionerControlScreen({super.key});
  static const id = "airconditionercontrolscreen";

  double _temperature = 24.0; // Default temperature
  String _mode = "Cool"; // Default mode
  int _fanSpeed = 2; // Default fan speed (1-3)

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Row(
                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
                    Text(
                      'Air Conditioner',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: CustomColor.greyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Temperature Control
              _buildTemperatureSlider(),
              const SizedBox(height: 40),
              // Mode Selection
              _buildModeSelector(),
              const SizedBox(height: 40),
              // Fan Speed Control
              _buildFanSpeedSelector(),
              const SizedBox(height: 40),
              // Power Button
              _buildPowerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Temperature',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CustomColor.greyTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _temperature,
          min: 16.0,
          max: 30.0,
          divisions: 14,
          label: _temperature.round().toString(),
          onChanged: (value) {
            _temperature = value;
          },
          activeColor: CustomColor.buttonBackgroundColor,
          inactiveColor: Colors.grey.shade300,
        ),
        Center(
          child: Text(
            '${_temperature.round()}°C',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColor.greyTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mode',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CustomColor.greyTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [
            _buildModeButton("Cool", _mode == "Cool"),
            _buildModeButton("Heat", _mode == "Heat"),
            _buildModeButton("Fan", _mode == "Fan"),
            _buildModeButton("Dry", _mode == "Dry"),
          ],
        ),
      ],
    );
  }

  Widget _buildModeButton(String mode, bool isSelected) {
    return ChoiceChip(
      label: Text(mode),
      selected: isSelected,
      onSelected: (selected) {
        _mode = mode;
      },
      selectedColor: CustomColor.buttonBackgroundColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : CustomColor.greyTextColor,
      ),
    );
  }

  Widget _buildFanSpeedSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fan Speed',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CustomColor.greyTextColor,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _fanSpeed.toDouble(),
          min: 1,
          max: 3,
          divisions: 2,
          label: _fanSpeed.toString(),
          onChanged: (value) {
            _fanSpeed = value.toInt();
          },
          activeColor: CustomColor.buttonBackgroundColor,
          inactiveColor: Colors.grey.shade300,
        ),
        Center(
          child: Text(
            'Level $_fanSpeed',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColor.greyTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPowerButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Simulate turning the AC on/off
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Air Conditioner is now ${_mode == "Off" ? "On" : "Off"}'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.buttonBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Power',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}