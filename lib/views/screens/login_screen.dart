import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homesync/models/app_user.dart';
import 'package:homesync/providers/user_provider.dart';
import 'package:homesync/services/api_service.dart';
import '../../configs/constants.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const id = "loginscreen";

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final HomeAssistantService haService = HomeAssistantService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await haService.fetchUserByUid(uid);
      if (user != null) {
        ref.read(userProvider.notifier).state = user;
      }

      Navigator.pushNamed(context, HomeScreen.id);
    } on FirebaseAuthException catch (e) {
      String message = 'Something went wrong';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
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
                const Center(
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
                buildInputField('Email address', _emailController, validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                }),
                const SizedBox(height: 20),
                buildInputField('Password', _passwordController, isPassword: true, validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your password';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                }),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.buttonBackgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                        : const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RegisterScreen.id),
                  child: Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {bool isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: CustomColor.greyTextColor.withOpacity(0.6)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
