import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/services/socket_io_service.dart';
import 'package:homesync/views/screens/devices_screen.dart';
import 'package:homesync/views/screens/forget_password_screen.dart';
import 'package:homesync/views/screens/ac_slider_screen.dart';
import 'package:homesync/views/screens/api_test_screen.dart';
import 'package:homesync/views/screens/home_screen.dart';
import 'package:homesync/views/screens/login_screen.dart';
import 'package:homesync/views/screens/register_screen.dart';
import 'package:homesync/views/screens/rooms_screen.dart';
import 'package:homesync/views/screens/sensor_rule_screen.dart';
import 'package:homesync/views/screens/smart_plug_screen.dart';
import 'package:homesync/views/screens/splash_screen_1.dart';
import 'package:homesync/views/screens/splash_screen_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final socketService = SocketIoService(
    serverUrl: 'http://192.168.151.76:5000', // Use local IP, HTTP is fine
  );
  socketService.connect(); // Connect early

  runApp(
    ProviderScope(
      overrides: [
        socketServiceProvider.overrideWithValue(socketService),
      ],
      child: HomeSyncApp(),
    ),
  );
}

class HomeSyncApp extends ConsumerWidget {
  HomeSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize WebSocket when app starts

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        SplashScreen1.id: (context) => const SplashScreen1(),
        SplashScreen2.id: (context) => const SplashScreen2(),
        LoginScreen.id: (context) => LoginScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        AirConditionerControlScreen.id: (context) => AirConditionerControlScreen(),
        SensorRuleScreen.id: (context) => SensorRuleScreen(),
        SmartPlugControlScreen.id: (context) => SmartPlugControlScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        RoomsPage.id: (context) => RoomsPage(),
        DevicePage.id: (context) => DevicePage(),
        RegisterScreen.id: (context) => RegisterScreen(),
        EntityListScreen.id: (context) => EntityListScreen()
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        fontFamily: 'Inter',
      ),
      home: const SplashScreen2(),
    );
  }
}
