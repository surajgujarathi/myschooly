import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myschooly/src/utils/colorsconstants.dart';

const Color schoolyLightBlue = Color(0xFFC3D0F6);
const Color schoolyDarkBlue = Color(0xFF1E3A8A);

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// =====================
                          /// ICON
                          /// =====================
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.18),
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// =====================
                          /// TITLE
                          /// =====================
                          const Text(
                            "You're Offline",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// =====================
                          /// DESCRIPTION
                          /// =====================
                          Text(
                            "No internet connection detected.\nPlease check your Wi-Fi or mobile data and try again.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 36),

                          /// =====================
                          /// TRY AGAIN BUTTON
                          /// =====================
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // trigger retry / connectivity check
                              },
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text(
                                "Try Again",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: schoolyDarkBlue,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// =====================
                          /// SMALL HINT
                          /// =====================
                          Text(
                            "Make sure you're connected to a network",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.75),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
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
