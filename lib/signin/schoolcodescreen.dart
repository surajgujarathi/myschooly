import 'package:flutter/material.dart';
import 'package:myschooly/src/utils/appconstants.dart';
import 'package:myschooly/viewcomponents/mstextfield.dart';
import 'package:provider/provider.dart';
import 'package:myschooly/src/providers/school_code_provider.dart';
import 'package:go_router/go_router.dart';

class SchoolCodeScreen extends StatefulWidget {
  const SchoolCodeScreen({super.key});

  @override
  State<SchoolCodeScreen> createState() => _SchoolCodeScreenState();
}

class _SchoolCodeScreenState extends State<SchoolCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/my skooly_white bg.png'), context);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<SchoolCodeProvider>(context, listen: false);
    await provider.verifyCode(_codeController.text.trim());
    if (!mounted) return;
    final status = provider.result?['status']?.toString();
    final role = provider.result?['user_role']?.toString();
    final ok = status == 'success';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Verified ($role)' : (provider.error ?? 'Verification failed'),
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    if (ok) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  /// Logo
                  Center(
                    child: Image.asset(
                      'assets/my skooly_white bg.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Title
                  const Text(
                    "Enter School Code",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Subtitle
                  const Text(
                    "Ask your school for the unique code",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),

                  const SizedBox(height: 40),

                  /// Input
                  MSFormField(
                    controller: _codeController,
                    type: MSFormFieldType.custom,
                    hintText: 'School Code (e.g. PHS)',
                    maxLength: 10,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'School code is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Code must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  /// Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: context.watch<SchoolCodeProvider>().isLoading
                          ? null
                          : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: schoolyDarkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0, // ✨ flat modern button
                      ),
                      child: context.watch<SchoolCodeProvider>().isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // /// Footer hint
                  // const Text(
                  //   "Need help? Contact your school admin",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 13, color: Colors.black45),
                  // ),

                  // const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
