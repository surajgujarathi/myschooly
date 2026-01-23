import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myschooly/signin/schoolcodescreen.dart';
import 'package:myschooly/signin/loginscreen.dart';
import 'package:myschooly/admin/admin_screen.dart';
import 'package:myschooly/src/screens/offline_screen.dart';
import 'package:myschooly/onboarding/onboarding_screen.dart';
import 'package:myschooly/src/providers/network_provider.dart';
import 'package:myschooly/src/providers/auth_provider.dart';

class AppRouter {
  static GoRouter build(NetworkProvider net, AuthProvider auth) {
    return GoRouter(
      refreshListenable: Listenable.merge([net, auth]),
      routes: [
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
          builder: (BuildContext context, GoRouterState state) =>
              const LoginScreen(),
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
        if (!auth.isInitialized) return null;

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

        // If we are on the offline screen (and now online), we must move away
        if (onOffline) {
          if (loggedIn && isCentral) {
            return '/admin';
          }
          return '/';
        }

        final onLogin = state.uri.path == '/login';
        final onRoot = state.uri.path == '/';

        if (loggedIn) {
          // If logged in and on login or root screen, redirect to admin (if role matches)
          if ((onLogin || onRoot) && isCentral) {
            return '/admin';
          }
        }

        return null;
      },
    );
  }
}
