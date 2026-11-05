import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class OTPService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _smtpUsername;
  final String _smtpPassword;
  final String _senderEmail;

  OTPService({
    required String smtpUsername,
    required String smtpPassword,
    required String senderEmail,
  }) : _smtpUsername = smtpUsername,
        _smtpPassword = smtpPassword,
        _senderEmail = senderEmail;

  Future<void> sendOTP(String recipientEmail) async {
    try {
      // Generate 6-digit OTP
      final otp = (100000 + Random().nextInt(900000)).toString();

      // Store in Firestore with expiration (5 minutes)
      await _firestore.collection('otp_verification').doc(recipientEmail).set({
        'otp': otp,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': DateTime.now().add(const Duration(minutes: 5)),
      });

      // Configure SMTP server (using Mailjet as example)
      final smtpServer = SmtpServer(
        'in-v3.mailjet.com',
        username: _smtpUsername,
        password: _smtpPassword,
        port: 587,
        allowInsecure: true,
        ssl: false
      );

      // Create email message
      final message = Message()
        ..from = Address(_senderEmail)
        ..recipients.add(recipientEmail)
        ..subject = 'Your OTP Code'
        ..text = 'Your verification code is: $otp\n\nThis code expires in 5 minutes.';

      // Send email
      await send(message, smtpServer);
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  Future<bool> verifyOTP(String email, String userEnteredOTP) async {
    try {
      final doc = await _firestore
          .collection('otp_verification')
          .doc(email)
          .get();

      if (!doc.exists) return false;

      final data = doc.data()!;
      final storedOTP = data['otp'].toString();
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();

      // Clean up OTP after verification attempt
      await doc.reference.delete();

      // Verify OTP and check expiration
      return storedOTP == userEnteredOTP && DateTime.now().isBefore(expiresAt);
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  // Optional: Cleanup expired OTPs
  Future<void> cleanupExpiredOTPs() async {
    final now = DateTime.now();
    final expiredOTPs = await _firestore
        .collection('otp_verification')
        .where('expiresAt', isLessThan: now)
        .get();

    final batch = _firestore.batch();
    for (final doc in expiredOTPs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}