import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/models/app_user.dart';
import 'package:homesync/providers/user_provider.dart';
import 'package:homesync/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs/constants.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static const id = "registerscreen";

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  final HomeAssistantService haService = HomeAssistantService();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Save user to backend (MongoDB via Flask API)
      await haService.createUser(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        uid,
      );

      // Fetch full user info
      final user = await haService.fetchUserByUid(uid);
      if (user != null) {
        ref.read(userProvider.notifier).state = user;

        // Mark user as logged in
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Registration failed';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text('Register',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: CustomColor.greyTextColor)),
                const SizedBox(height: 40),
                buildInputField('Username', _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                buildInputField('Email address', _emailController,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                buildInputField('Password', _passwordController,
                    isPassword: true, validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    }),
                const SizedBox(height: 20),
                buildInputField('Confirm Password',
                    _confirmPasswordController,
                    isPassword: true, validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }),
                const SizedBox(height: 32),
                if (_errorMessage.isNotEmpty)
                  Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.buttonBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('SIGN UP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, LoginScreen.id),
                  child: Text('Already have an account? Login',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 14)),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      {bool isPassword = false,
        String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        TextStyle(color: CustomColor.greyTextColor.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
