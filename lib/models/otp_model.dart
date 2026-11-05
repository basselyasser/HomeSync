import '../configs/app_config.dart';
import '../services/otp_service.dart';

class OTPModel {
  final OTPService otpService;

  OTPModel()
      : otpService = OTPService(
    smtpUsername: AppConfig.smtpUsername,
    smtpPassword: AppConfig.smtpPassword,
    senderEmail: AppConfig.senderEmail,
  );
}
