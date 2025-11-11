import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/shared_prefs_service.dart';
import 'services/theme_provider.dart';
import 'theme/app_theme.dart';
import 'Models/app_state.dart';
import 'Screens/role_select.dart';
import 'Screens/child_dashboard.dart';
import 'Screens/parent_dashboard.dart';
import 'Screens/redeem_screen.dart';
import 'Screens/games_placeholder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase only on mobile and web platforms
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error during Firebase initialization: $e');
    }
  } else {
    print('Firebase skipped on desktop platform (will use local storage)');
  }
  
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
      title: 'GreenTime Kids',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
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
  
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authToken = await SharedPrefsService.getString('auth_token');
    if (authToken != null) {
      setState(() {
        _isAuthenticated = true;
      });
      if (mounted) {
        Provider.of<AppState>(context, listen: false).setUserId('test_user_123');
      }
    }
    setState(() {
      _isLoading = false;
    });
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
    
    if (!_isAuthenticated) {
      return const RoleSelectScreen();
    }

    // For testing, you can hardcode the role here
    const isKid = true;  // Change to false to see parent dashboard
    return isKid ? const ChildDashboard() : const ParentDashboard();
  }
}