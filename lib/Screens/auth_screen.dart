import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Models/app_state.dart';
import '../services/tinydb_service.dart';
import '../services/auth_service.dart';
import 'child_dashboard.dart';
import 'parent_dashboard.dart';

class AuthScreen extends StatefulWidget {
  final String role;
  const AuthScreen({Key? key, required this.role}) : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = ''; // For child accounts
  bool _isLogin = true;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      
      try {
        String? userId;
        if (_isLogin) {
          userId = await AuthService.signIn(_email, _password);
        } else {
          // For children signing up, ensure username is set
          if (widget.role == 'kid' && _username.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please create a username'), backgroundColor: Colors.red),
            );
            return;
          }
          userId = await AuthService.signUp(_email, _password, _username, widget.role);
        }

        if (userId != null) {
          Provider.of<AppState>(context, listen: false).setUserId(userId,
            username: _username.isNotEmpty ? _username : null);
          
          if (widget.role == 'kid') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ChildDashboard()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ParentDashboard()));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Welcome Back' : 'Create Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: widget.role == 'kid'
                ? [const Color(0xFF29B6F6), const Color(0xFF0288D1)]
                : [const Color(0xFF66BB6A), const Color(0xFF388E3C)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isTabletOrDesktop ? size.width * 0.2 : 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Username field for children during signup
                      if (widget.role == 'kid' && !_isLogin)
                        Column(
                          children: [
                            TextFormField(
                              key: const ValueKey('username'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please choose a username';
                                }
                                if (value.length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                  return 'Username can only contain letters, numbers, and underscores';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value ?? '';
                              },
                              decoration: InputDecoration(
                                labelText: 'Create Username',
                                hintText: 'e.g., eco_warrior_123',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                helperText: 'This is how your parent will find you',
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _trySubmit,
                        child: Text(
                          _isLogin ? 'Login' : 'Signup',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          _isLogin ? 'Create new account' : 'I already have an account',
                          style: GoogleFonts.poppins(),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _username = ''; // Clear username when toggling
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}