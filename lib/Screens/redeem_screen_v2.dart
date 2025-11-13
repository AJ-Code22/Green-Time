import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Models/app_state.dart';
import '../services/tinydb_service.dart';
import '../utils/responsive_helper.dart';

class RedeemScreen extends StatefulWidget {
  const RedeemScreen({Key? key}) : super(key: key);

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  bool _showWebView = false;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _initializeWebView();
  }

  Future<void> _checkUserRole() async {
  final role = await TinyDB.getString('current_role');
    setState(() {
      _userRole = role;
    });
    // Only parents can access redeem
    if (role != 'parent') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only parents can access the redeem page'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading page: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://ecomart.zone.id/landing'));
  }

  Future<void> _deductPoints(int points) async {
  final userId = await TinyDB.getString('current_user');
    if (userId != null) {
      try {
        // Mock implementation - update AppState
        Provider.of<AppState>(context, listen: false).deductEcoPoints(points);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Redeemed successfully! $points EcoPoints deducted.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error redeeming reward: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final padding = ResponsiveHelper.getResponsivePadding(context);

    // If user is not a parent, show access denied message
    if (_userRole != null && _userRole != 'parent') {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Redeem Rewards',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'Access Restricted',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Only parents can access the redeem rewards page.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Redeem Rewards',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Chip(
                label: Text(
                  'EcoPoints: ${appState.ecoPoints}',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
      body: _showWebView && _userRole == 'parent'
          ? _buildWebView()
          : _buildRedeemOptions(context, appState, isMobile, padding),
    );
  }

  Widget _buildRedeemOptions(
    BuildContext context,
    AppState appState,
    bool isMobile,
    EdgeInsets padding,
  ) {
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Redeem Your EcoPoints',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You have earned ${appState.ecoPoints} EcoPoints!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Exchange them for amazing eco-friendly products and rewards.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Info Cards
          _buildInfoCard(
            context,
            Icons.shopping_bag_outlined,
            'Browse Products',
            'Explore our collection of eco-friendly products',
          ),
          const SizedBox(height: 12),
          
          _buildInfoCard(
            context,
            Icons.verified_user_outlined,
            'Secure Purchase',
            'Safe and secure checkout process',
          ),
          const SizedBox(height: 12),
          
          _buildInfoCard(
            context,
            Icons.local_shipping_outlined,
            'Fast Delivery',
            'Quick shipping to your address',
          ),
          const SizedBox(height: 32),
          
          // Main CTA Button
          ElevatedButton.icon(
            onPressed: appState.ecoPoints > 0 
                ? () {
                    setState(() {
                      _showWebView = true;
                    });
                  }
                : null,
            icon: const Icon(Icons.launch, size: 24),
            label: const Text(
              'Start Shopping at EcoMart',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Additional Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
              ),
                const SizedBox(height: 8),
                Text(
                  'Tip: More eco-friendly activities earn more EcoPoints!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).primaryColor,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
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

  Widget _buildWebView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showWebView = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Text(
                  'EcoMart Store',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                onPressed: () {
                  _webViewController.reload();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: _webViewController),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
