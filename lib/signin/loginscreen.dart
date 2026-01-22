import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:go_router/go_router.dart';
import 'package:myschooly/signin/forgotpasswordscreen.dart';
import 'package:myschooly/src/providers/auth_provider.dart';
import 'package:myschooly/viewcomponents/mstextfield.dart';

/// =====================
/// COLOR CONSTANTS
/// =====================
const Color schoolyLightBlue = Color(0xFFC3D0F6);
const Color schoolyPrimaryBlue = Color(0xFF3B82F6);
const Color schoolyDarkBlue = Color(0xFF1E3A8A);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/my skooly_white bg.png'), context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.login(_emailController.text.trim(), _passwordController.text);

    if (!mounted) return;

    final ok = auth.error == null;
    if (ok) {
      if (auth.userRole == 'central') {
        context.go('/admin');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: Stack(
        children: [
          /// =====================
          /// BACKGROUND GRADIENT
          /// =====================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [schoolyLightBlue, schoolyPrimaryBlue],
              ),
            ),
          ),

          /// =====================
          /// DECOR CIRCLE
          /// =====================
          Positioned(
            top: -60,
            right: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// =====================
                      /// LOGO
                      /// =====================
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/my skooly_white bg.png',
                          height: 90,
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// =====================
                      /// GLASS CARD
                      /// =====================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TITLE
                                const Text(
                                  "Welcome Back",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// SUBTITLE
                                Text(
                                  "Sign in to continue",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                /// EMAIL
                                Theme(
                                  data: Theme.of(
                                    context,
                                  ).copyWith(primaryColor: Colors.white),
                                  child: MSFormField(
                                    controller: _emailController,
                                    labelText: "Email",
                                    hintText: "yourname@email.com",
                                    prefixIcon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Email is required';
                                      }

                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// PASSWORD
                                MSFormField(
                                  controller: _passwordController,
                                  labelText: "Password",
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Password is required';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 12),

                                /// FORGOT PASSWORD
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                /// LOGIN BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: schoolyDarkBlue,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "Sign In",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
