import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myschooly/signin/schoolcodescreen.dart';
import 'package:myschooly/signin/loginscreen.dart';
import 'package:myschooly/admin/admin_screen.dart';
import 'package:myschooly/src/screens/offline_screen.dart';
import 'package:myschooly/src/screens/splash_screen.dart';
import 'package:myschooly/onboarding/onboarding_screen.dart';
import 'package:myschooly/src/providers/network_provider.dart';
import 'package:myschooly/src/providers/auth_provider.dart';

// Student Imports
import 'package:myschooly/student/student_layout.dart';
import 'package:myschooly/student/screens/dashboard_screen.dart';
import 'package:myschooly/student/screens/timetable_screen.dart';
import 'package:myschooly/student/screens/assignments_screen.dart';
import 'package:myschooly/student/screens/messages_screen.dart';
import 'package:myschooly/student/screens/results_screen.dart';
import 'package:myschooly/student/screens/fees_screen.dart';
import 'package:myschooly/student/screens/materials_screen.dart';
import 'package:myschooly/student/screens/reports_screen.dart';
import 'package:myschooly/student/screens/events_screen.dart';

class AppRouter {
  static GoRouter build(NetworkProvider net, AuthProvider auth) {
    return GoRouter(
      refreshListenable: Listenable.merge([net, auth]),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (BuildContext context, GoRouterState state) =>
              const SplashScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const SchoolCodeScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (BuildContext context, GoRouterState state) =>
              const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => LoginScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (BuildContext context, GoRouterState state) =>
              const AdminScreen(),
        ),
        GoRoute(
          path: '/offline',
          builder: (BuildContext context, GoRouterState state) =>
              const OfflineScreen(),
        ),

        // Student Routes with Shell
        ShellRoute(
          builder: (context, state, child) {
            return StudentLayout(child: child);
          },
          routes: [
            GoRoute(
              path: '/student',
              builder: (context, state) => const DashboardScreen(),
              routes: [
                GoRoute(
                  path: 'timetable',
                  builder: (context, state) => const TimetableScreen(),
                ),
                GoRoute(
                  path: 'assignments',
                  builder: (context, state) => const AssignmentsScreen(),
                ),
                GoRoute(
                  path: 'messages',
                  builder: (context, state) => const MessagesScreen(),
                ),
                GoRoute(
                  path: 'results',
                  builder: (context, state) => const ResultsScreen(),
                ),
                GoRoute(
                  path: 'fees',
                  builder: (context, state) => const FeesScreen(),
                ),
                GoRoute(
                  path: 'materials',
                  builder: (context, state) => const MaterialsScreen(),
                ),
                GoRoute(
                  path: 'reports',
                  builder: (context, state) => const ReportsScreen(),
                ),
                GoRoute(
                  path: 'events',
                  builder: (context, state) => const EventsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final offline = !net.isOnline;
        final onOffline = state.uri.path == '/offline';

        // 1. Handle going offline
        if (offline && !onOffline) return '/offline';

        // If currently offline and network is still down, stay here.
        if (offline) return null;

        // 2. Handle coming back online or normal navigation
        // Wait for auth initialization
        if (!auth.isInitialized || !auth.minSplashElapsed) return '/splash';

        final onSplash = state.uri.path == '/splash';
        if (onSplash && auth.isInitialized && auth.minSplashElapsed) {
          if (!auth.onboardingSeen) return '/onboarding';
          if (auth.isAuthenticated) {
            final isCentral = auth.userRole == 'central';
            return isCentral ? '/admin' : '/student';
          }
          return '/';
        }

        final onOnboarding = state.uri.path == '/onboarding';

        // 3. Handle Onboarding
        if (!auth.onboardingSeen) {
          if (!onOnboarding) return '/onboarding';
          return null; // Stay on onboarding
        }

        // If onboarding is seen but we are on onboarding page, go to root
        if (onOnboarding && auth.onboardingSeen) {
          return '/';
        }

        final loggedIn = auth.isAuthenticated;
        final isCentral = auth.userRole == 'central';
        final isStudentOrParent =
            auth.userRole !=
            'central'; // Assuming non-central is student/parent

        // If we are on the offline screen (and now online), we must move away
        if (onOffline) {
          if (loggedIn) {
            if (isCentral) return '/admin';
            return '/student';
          }
          return '/';
        }

        final onLogin = state.uri.path == '/login';
        final onRoot = state.uri.path == '/';

        if (loggedIn) {
          // If logged in and on login or root screen, redirect based on role
          if (onLogin || onRoot) {
            if (isCentral) {
              return '/admin';
            } else {
              return '/student';
            }
          }
        }

        return null;
      },
    );
  }
}
