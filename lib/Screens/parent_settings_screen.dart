import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Models/app_state.dart';
import '../services/auth_service.dart';
import '../services/tinydb_service.dart';
import 'role_select.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  String? _linkedEmail;
  bool _isLoading = false;
  bool _isGmailLinked = false;

  @override
  void initState() {
    super.initState();
    _loadGmailStatus();
  }

  Future<void> _loadGmailStatus() async {
    try {
  final linkedEmail = await TinyDB.getString('linked_gmail');
      setState(() {
        _linkedEmail = linkedEmail;
        _isGmailLinked = linkedEmail != null && linkedEmail.isNotEmpty;
      });
    } catch (e) {
      print('Error loading Gmail status: $e');
    }
  }

  Future<void> _linkGmail() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.linkWithGoogle();
      await _loadGmailStatus(); // Reload the status after linking
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Gmail account linked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error linking Gmail: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _unlinkGmail() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unlink Gmail Account'),
        content: const Text('Are you sure you want to unlink your Gmail account? You can still manage tasks without it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Unlink', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
  await TinyDB.setString('linked_gmail', '');
        setState(() {
          _linkedEmail = null;
          _isGmailLinked = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Gmail account unlinked'),
            backgroundColor: Colors.orange,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error unlinking Gmail: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await AuthService.signOut();
              
              // Sign out from AppState
              if (mounted) {
                Provider.of<AppState>(context, listen: false).resetState();
                Navigator.pop(ctx);
                // Navigate back to role select
                Navigator.pushNamedAndRemoveUntil(context, '/role-select', (route) => false);
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrDesktop = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parent Settings',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF388E3C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTabletOrDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gmail Linking Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gmail Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1976D2),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Link your Gmail to manage tasks and notifications',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_isGmailLinked && _linkedEmail != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Connected',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      Text(
                                        _linkedEmail!,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.green[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _unlinkGmail,
                          icon: const Icon(Icons.link_off, color: Colors.white),
                          label: Text(
                            'Unlink Gmail',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Not connected. Link your Gmail to get started.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _linkGmail,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.mail_outline, color: Colors.white),
                          label: Text(
                            _isLoading ? 'Linking...' : 'Link Gmail Account',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Benefits Section
            Text(
              'Benefits of Linking Gmail',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF388E3C),
              ),
            ),
            const SizedBox(height: 12),
            _BenefitTile(
              icon: Icons.notifications_none,
              title: 'Task Notifications',
              description: 'Receive email updates when children complete tasks',
            ),
            _BenefitTile(
              icon: Icons.cloud_sync,
              title: 'Cloud Sync',
              description: 'Keep your tasks and children profiles synced across devices',
            ),
            _BenefitTile(
              icon: Icons.security,
              title: 'Secure Recovery',
              description: 'Use your Gmail to recover your account if needed',
            ),
            _BenefitTile(
              icon: Icons.analytics,
              title: 'Weekly Reports',
              description: 'Get weekly summaries of your children\'s progress via email',
            ),

            const SizedBox(height: 24),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _showSignOutDialog(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  'Sign Out',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF66BB6A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF66BB6A)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleSignInDialog extends StatefulWidget {
  final Function(String email) onConfirm;

  const _GoogleSignInDialog({required this.onConfirm});

  @override
  State<_GoogleSignInDialog> createState() => _GoogleSignInDialogState();
}

class _GoogleSignInDialogState extends State<_GoogleSignInDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Link Gmail Account',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your Gmail email address to link your account:',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Gmail Address',
                hintText: 'example@gmail.com',
                prefixIcon: const Icon(Icons.mail_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Gmail address';
                }
                if (!value.contains('@gmail.com')) {
                  return 'Please enter a valid Gmail address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onConfirm(_emailController.text);
              Navigator.pop(context);
            }
          },
          child: const Text(
            'Link',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
