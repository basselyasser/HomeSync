import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homesync/configs/app_config.dart';
import 'package:homesync/services/api_service.dart';
import 'package:homesync/view_models/entity_view_model.dart';
import 'package:homesync/views/widgets/sensor_entity_card.dart';
import 'package:homesync/views/widgets/switch_entity_card.dart';
import 'package:homesync/views/widgets/weather_card.dart';
import 'package:homesync/views/screens/login_screen.dart';
import '../../models/entity_model.dart';
import '../../models/switch_entity_model.dart';
import '../../providers/prediction_provider.dart';
import '../widgets/number_entity_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const id = "HomeScreen";
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final EntityViewModel viewModel = EntityViewModel();
  final HomeAssistantService haService = HomeAssistantService();
  List<SwitchEntity> switchEntities = [];
  List<Entity> sensorEntities = [];
  List<Entity> numberEntities = [];

  Map<String, dynamic>? weatherData;
  bool isLoadingWeather = true;
  Timer? _weatherTimer;

  String? username;
  bool isUsernameLoading = true;

  @override
  void initState() {
    super.initState();
    loadSwitchEntities();
    loadWeather();
    fetchUsername();

    _weatherTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadWeather();
    });
  }

  @override
  void dispose() {
    _weatherTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchUsername() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final fetchedUser = await haService.fetchUserByUid(uid);
    if (!mounted) return;
    setState(() {
      username = fetchedUser?.username ?? 'Guest';
      isUsernameLoading = false;
    });
  }

  Future<void> loadSwitchEntities() async {
    final fetchedEntities = await viewModel.fetchSwitchEntities();
    final fetchedSensors = await viewModel.fetchSensorEntities();
    final fetchedNumberEntities = await viewModel.fetchNumberEntities();
    setState(() {
      switchEntities = fetchedEntities;
      sensorEntities = fetchedSensors;
      numberEntities = fetchedNumberEntities;
    });
  }

  Future<void> loadWeather() async {
    final data = await haService.fetchWeatherData();
    setState(() {
      weatherData = data;
      isLoadingWeather = false;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.id);
  }

  IconData _mapStringToIcon(String input) {
    switch (input.toLowerCase()) {
      case 'cloud':
      case 'cloudy':
        return Icons.cloud;
      case 'sun':
      case 'sunny':
        return Icons.wb_sunny;
      case 'rain':
        return Icons.grain;
      case 'fog':
        return Icons.blur_on;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }

  void showBillPredictionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bill Prediction'),
          content: Consumer(
            builder: (context, ref, _) {
              final prediction = ref.watch(predictionProvider);
              const double egpPerKwh = 1.3;

              if (prediction == null) {
                return const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final egp = prediction * egpPerKwh;
              final now = DateTime.now();
              final firstOfNextMonth = DateTime(now.year, now.month + 1, 1);
              final lastOfNextMonth =
              DateTime(firstOfNextMonth.year, firstOfNextMonth.month, 0);
              final formattedDate =
                  "${lastOfNextMonth.year}-${lastOfNextMonth.month.toString().padLeft(2, '0')}-${lastOfNextMonth.day.toString().padLeft(2, '0')}";

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Predicted Usage: ${prediction.toStringAsFixed(2)} kWh',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prediction Date: $formattedDate',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estimated Bill: ${egp.toStringAsFixed(2)} EGP',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          await loadSwitchEntities();
          await loadWeather();
          await AppConfig.loadIpAddress();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B9080),
                      ),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      tooltip: 'Logout',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      isUsernameLoading ? 'Loading...' : (username ?? 'Guest'),
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B9080),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        showBillPredictionDialog(context, ref);
                      },
                      icon: const Icon(Icons.receipt),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: isLoadingWeather
                      ? const Center(child: CircularProgressIndicator())
                      : weatherData != null
                      ? WeatherCard(
                    location: weatherData!['location'] ?? 'Unknown',
                    condition: weatherData!['condition'] ?? 'Clear',
                    temperature:
                    (weatherData!['temperature_celsius'] as num)
                        .round(),
                    icon: _mapStringToIcon(
                        weatherData!['condition'] ?? 'cloudy'),
                  )
                      : const Center(child: Text('Failed to load weather')),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Devices',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 200,
                    ),
                    itemCount: switchEntities.length +
                        sensorEntities.length +
                        numberEntities.length,
                    itemBuilder: (context, index) {
                      if (index < switchEntities.length) {
                        return SwitchCard(entity: switchEntities[index]);
                      } else if (index <
                          switchEntities.length + sensorEntities.length) {
                        final sensorIndex = index - switchEntities.length;
                        return SensorCard(
                            sensorEntity: sensorEntities[sensorIndex]);
                      } else {
                        final numberIndex = index -
                            switchEntities.length -
                            sensorEntities.length;
                        return ServoSliderCard(
                            entity: numberEntities[numberIndex]);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
