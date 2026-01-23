import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myschooly/src/providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Welcome to\nMySkooly',
      description:
          'Your complete solution for school management and communication.',
      icon: Icons.auto_awesome_rounded,
      color: const Color(0xFF6366F1),
    ),
    OnboardingContent(
      title: 'Stay\nConnected',
      description: 'Track attendance, grades, and announcements in real-time.',
      icon: Icons.diversity_3_rounded,
      color: const Color(0xFFF59E0B),
    ),
    OnboardingContent(
      title: 'Easy\nManagement',
      description:
          'Streamline tasks and focus on what matters most - education.',
      icon: Icons.rocket_launch_rounded,
      color: const Color(0xFF10B981),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles the Auth Logic to persist onboarding completion
  Future<void> _handleCompleteOnboarding() async {
    final auth = context.read<AuthProvider>();

    // We await the provider logic (e.g., saving a 'hasSeenOnboarding' flag to SharedPreferences)
    await auth.completeOnboarding();

    if (mounted) {
      // Navigate to the root/home route using GoRouter
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Decorative Background Blobs
          Positioned(
            top: -100,
            right: -50,
            child: _buildBlob(
              250,
              _contents[_currentPage].color.withOpacity(0.15),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -80,
            child: _buildBlob(300, const Color(0xFFE0E7FF).withOpacity(0.6)),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _contents.length,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return _buildPage(_contents[index]);
                    },
                  ),
                ),
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Icon Container with Glassmorphism
          TweenAnimationBuilder(
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0.8, end: 1.0),
            curve: Curves.elasticOut,
            builder: (context, double value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: content.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: content.color.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(content.icon, size: 90, color: content.color),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Color(0xFF475569),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
      child: Column(
        children: [
          // Active Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _contents.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.only(right: 8),
                height: 8,
                width: _currentPage == index ? 32 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? _contents[_currentPage].color
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Primary Action Button
          SizedBox(
            width: double.infinity,
            height: 62,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _contents.length - 1) {
                  _handleCompleteOnboarding();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _contents[_currentPage].color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _currentPage == _contents.length - 1
                      ? 'Get Started'
                      : 'Continue',
                  key: ValueKey<int>(_currentPage),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Skip Button
          if (_currentPage != _contents.length - 1)
            TextButton(
              onPressed: _handleCompleteOnboarding,
              child: const Text(
                'Skip for now',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const SizedBox(height: 48), // Maintain layout height consistency
        ],
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
