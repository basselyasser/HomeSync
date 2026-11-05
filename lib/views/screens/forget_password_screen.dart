import 'package:flutter/material.dart';
import '../../configs/constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  static const id = "forgotpasswordscreen";
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
              const SizedBox(height: 60),
              Center(
                child: Text(
                  'HomeSync',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: CustomColor.greyTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.greyTextColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Please enter your email address to receive a password reset link',
                style: TextStyle(
                  color: CustomColor.greyTextColor.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              _buildInputField('Email address', _emailController),
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Back to Login',
                    style: TextStyle(
                      color: CustomColor.greyTextColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: CustomColor.greyTextColor.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Handle password reset
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.buttonBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'SUBMIT',
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