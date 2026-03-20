import 'package:flutter/material.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({super.key});

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF90C0E1D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 20),
              // Title
              const Center(
                child: Text(
                  'Create your account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Sign up to start your learning journey',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                ),
              ),
              const SizedBox(height: 32),
              // Email field
              _buildLabel('Email'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('user@email.com'),
              ),
              const SizedBox(height: 20),
              // Username field
              _buildLabel('Username'),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Choose a username'),
              ),
              const SizedBox(height: 20),
              // Password field
              _buildLabel('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: _obscurePassword,
                decoration: _inputDecoration('Create a password').copyWith(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/learning-preferences');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 24),
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                ],
              ),
              const SizedBox(height: 24),
              // Google sign up
              _buildSocialButton(
                icon: const Text('G', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                label: 'Sign up with Google',
              ),
              const SizedBox(height: 14),
              // Apple sign up
              _buildSocialButton(
                icon: const Icon(Icons.apple, color: Colors.white, size: 24),
                label: 'Sign up with Apple',
              ),
              const SizedBox(height: 24),
              // Already have account
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Color(0xFF2196F3),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildSocialButton({required Widget icon, required String label}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D2137),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}
