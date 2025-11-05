import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_prefs_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isChild = true;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Simple local "login": store username and role
    await SharedPrefsService.setUsername(_username);
    await SharedPrefsService.setIsChild(_isChild);

    if (_isChild) {
      Navigator.pushReplacementNamed(context, '/child-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/parent-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLarge = size.width > 600;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isLarge ? 48 : 24, vertical: 24),
            child: FadeTransition(
              opacity: _animController.drive(CurveTween(curve: Curves.easeIn)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Text('GreenTime', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 8),
                  Text('Earn screen minutes for doing good!', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Email or username', prefixIcon: Icon(Icons.person)),
                              onSaved: (v) => _username = v?.trim() ?? '',
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a username' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock)),
                              obscureText: true,
                              onSaved: (v) => _password = v ?? '',
                              validator: (v) => (v == null || v.isEmpty) ? 'Enter a password' : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    child: const Text('Sign in'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ToggleButtons(
                              isSelected: [_isChild, !_isChild],
                              onPressed: (i) => setState(() => _isChild = i == 0),
                              borderRadius: BorderRadius.circular(12),
                              children: const [Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Child')), Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Parent'))],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/games'),
                    child: const Text('Try mini-games (placeholder)'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
