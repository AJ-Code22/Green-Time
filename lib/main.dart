import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/tinydb_service.dart';
import 'services/auth_service.dart';
import 'services/theme_provider.dart';
import 'theme/app_theme_modern.dart';
import 'Models/app_state.dart';
import 'Screens/role_select.dart';
import 'Screens/child_dashboard.dart';
import 'Screens/parent_dashboard.dart';
import 'Screens/redeem_screen.dart';
import 'Screens/games_placeholder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const EcoMartKidsApp(),
    ),
  );
}

class EcoMartKidsApp extends StatelessWidget {
  const EcoMartKidsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenTime - Family & Eco',
      theme: AppThemeModern.getLightTheme(),
      darkTheme: AppThemeModern.getDarkTheme(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AuthWrapper(),
      routes: {
        '/child-dashboard': (context) => const ChildDashboard(),
        '/parent-dashboard': (context) => const ParentDashboard(),
        '/redeem': (context) => const RedeemScreen(),
        '/games': (context) => const GamesPlaceholder(),
        '/role-select': (context) => const RoleSelectScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _userRole;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

    Future<void> _checkAuth() async {
      try {
  _isAuthenticated = await AuthService.isSignedIn();
  _userRole = await AuthService.getCurrentUserRole();
  final userId = await AuthService.getCurrentUserId();
  
        if (_isAuthenticated && userId != null && _userRole != null) {
          if (mounted) {
            Provider.of<AppState>(context, listen: false).setUserId(userId);
          }
        } else {
          // Clear any lingering data if auth check fails
          await TinyDB.clear();
        }
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Auth check error: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = e.toString();
          });
        }
      }
    }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Initialization Error'),
              const SizedBox(height: 8),
              Text(_error ?? 'Unknown error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _checkAuth();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (!_isAuthenticated || _userRole == null) {
      return const RoleSelectScreen();
    }

    if (_userRole == 'kid') {
      return const ChildDashboard();
    } else {
      return const ParentDashboard();
    }
  }
}