import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String location;
  final String condition;
  final int temperature;
  final IconData icon;

  const WeatherCard({
    super.key,
    required this.location,
    required this.condition,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB4C7BD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(icon, color: Colors.white.withOpacity(0.9), size: 20),
                    const SizedBox(width: 4),
                    Text(condition,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Text('$temperature°',
              style: const TextStyle(
                  fontSize: 38, fontWeight: FontWeight.w500, color: Colors.white)),
        ],
      ),
    );
  }
}
