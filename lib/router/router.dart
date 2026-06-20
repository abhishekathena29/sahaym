import 'package:bridging_saathi/screens/main_screen.dart';
import 'package:bridging_saathi/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Create a class to handle authentication state changes
class AuthState extends ChangeNotifier {
  bool _isAuth = false;
  bool _initialized = false;

  bool get isAuth => _isAuth;
  bool get initialized => _initialized;

  AuthState() {
    _initialized = true;
  }

  void setAuth(bool value) {
    if (value != _isAuth || !_initialized) {
      _isAuth = value;
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    _initialized = true;
    notifyListeners();
  }
}

// Create a global instance that can be accessed anywhere
final authState = AuthState();

// Create the router with the auth state
final router = GoRouter(
  initialLocation: '/mainScreen',
  refreshListenable:
      authState, // This ensures router refreshes when auth state changes
  routes: [
    GoRoute(
      path: '/mainScreen',
      name: 'main_screen',
      builder: (context, state) => const MainScreen(),
    ),

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),
    // Add more routes here as needed
  ],
);
