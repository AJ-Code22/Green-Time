import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/login_screen.dart';
import 'Screens/child_dashboard.dart';
import 'Screens/parent_dashboard.dart';
import 'Screens/redeem_screen.dart';
import 'Screens/games_placeholder.dart';
import 'services/shared_prefs_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  runApp(const EcoMartKidsApp());
}

class EcoMartKidsApp extends StatelessWidget {
  const EcoMartKidsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seed = const Color(0xFF2E7D32); // green
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GreenTime Kids',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/child-dashboard': (context) => const ChildDashboard(),
        '/parent-dashboard': (context) => const ParentDashboard(),
        '/redeem': (context) => const RedeemScreen(),
        '/games': (context) => const GamesPlaceholder(),
      },
    );
  }
}

