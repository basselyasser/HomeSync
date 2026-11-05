import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final predictionProvider = StateNotifierProvider<PredictionNotifier, double?>((ref) {
  return PredictionNotifier();
});

class PredictionNotifier extends StateNotifier<double?> {
  Timer? _timer;

  PredictionNotifier() : super(null) {
    fetchPrediction(); // Initial fetch
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchPrediction());
  }

  Future<void> fetchPrediction() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.151.76:5000/predict-electricity'), // <- Use dash here
        headers: {"Content-Type": "application/json"},
      );


      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        state = (json["next_week_prediction"]["predicted_consumption_kwh"] as num).toDouble() * 2; // adjust key if needed
        print("Updated prediction");
      } else {
        print("Failed to load prediction: ${response.statusCode}");
      }
    } catch (e) {
      print("Prediction fetch error: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
