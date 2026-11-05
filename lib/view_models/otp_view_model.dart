// view_model/otp_view_model.dart
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import '../services/otp_service.dart';

class OTPViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendOTP(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      OTPService otpService = OTPService(
        smtpUsername: AppConfig.smtpUsername,
        smtpPassword: AppConfig.smtpPassword,
        senderEmail: AppConfig.senderEmail,
      );
      await otpService.sendOTP(email);
      print('OTP sent successfully!');
      // You can also add success state here if needed
    } catch (e) {
      print('Failed to send OTP: ${e.toString()}');
      // Handle the error state here if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
