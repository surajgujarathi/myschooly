import 'package:flutter/material.dart';
import 'package:myschooly/src/utils/colorsconstants.dart'; // ← schoolyDarkBlue is here

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container (same style as lock_reset in forgot password)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: schoolyDarkBlue.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 90,
                    color: schoolyDarkBlue,
                  ),
                ),

                const SizedBox(height: 40),

                // Main title
                const Text(
                  "You're Offline",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  "No internet connection detected.\nPlease check your Wi-Fi or mobile data and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // Try Again button (same style as Send Reset Link)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // You can add connectivity check or refresh logic here
                      // Navigator.pop(context); // or trigger reconnection
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    label: const Text(
                      "Try Again",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: schoolyDarkBlue,
                      foregroundColor: Colors.white,
                      elevation: 0, // flat modern look like your reference
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Optional small hint
                Text(
                  "Make sure you're connected to a network",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
