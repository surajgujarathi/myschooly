import 'package:flutter/material.dart';
import 'package:myschooly/src/utils/colorsconstants.dart';
import 'package:myschooly/viewcomponents/mstextfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigator.pop(context); // Go back to Login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// App bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: const Text(
          "Create Account",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  /// Subtitle
                  const Text(
                    "Join MySkooly today",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),

                  const SizedBox(height: 40),

                  /// Full name
                  MSFormField(
                    type: MSFormFieldType.fullName,
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  /// Email
                  MSFormField(
                    type: MSFormFieldType.email,
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  /// Phone
                  MSFormField(
                    type: MSFormFieldType.phoneNumber,
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  /// Password
                  MSFormField(
                    type: MSFormFieldType.password,
                    controller: _passwordController,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20),

                  /// Confirm password
                  MSFormField(
                    type: MSFormFieldType.confirmPassword,
                    controller: _confirmPasswordController,
                    passwordToMatch: _passwordController.text,
                    textInputAction: TextInputAction.done,
                  ),

                  const SizedBox(height: 36),

                  /// Sign up button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: schoolyDarkBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: schoolyDarkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
