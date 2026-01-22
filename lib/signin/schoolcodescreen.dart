import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:myschooly/src/providers/school_code_provider.dart';
import 'package:myschooly/viewcomponents/mstextfield.dart';

/// =====================
/// COLOR CONSTANTS
/// =====================
const Color schoolyLightBlue = Color(0xFFC3D0F6);
const Color schoolyPrimaryBlue = Color(0xFF3B82F6);
const Color schoolyDarkBlue = Color(0xFF1E3A8A);

class SchoolCodeScreen extends StatefulWidget {
  const SchoolCodeScreen({super.key});

  @override
  State<SchoolCodeScreen> createState() => _SchoolCodeScreenState();
}

class _SchoolCodeScreenState extends State<SchoolCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final code = _codeController.text.trim().toUpperCase();
    final provider = Provider.of<SchoolCodeProvider>(context, listen: false);

    await provider.verifyCode(code);

    if (!mounted) return;

    final status = provider.result?['status']?.toString();

    if (status == 'success') {
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.result?['message'] ?? 'Verification failed'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<SchoolCodeProvider>().isLoading;

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
          /// BACKGROUND DECOR
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
                          height: 100,
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
                                  "School Portal",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                /// SUBTITLE
                                Text(
                                  "Enter your unique institutional code to access your dashboard.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.4,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),

                                const SizedBox(height: 32),

                                /// SCHOOL CODE INPUT
                                Theme(
                                  data: Theme.of(
                                    context,
                                  ).copyWith(primaryColor: Colors.white),
                                  child: MSFormField(
                                    controller: _codeController,
                                    hintText: 'e.g. SCH-7890',
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter school code';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(height: 32),

                                /// GET STARTED BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _handleSubmit,
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
                                            "Get Started",
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

                      /// HELP TEXT
                      Text(
                        "Need help finding your code?",
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
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
