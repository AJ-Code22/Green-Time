import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/services/auth_service.dart';
import 'package:hi/services/tinydb_service.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({Key? key}) : super(key: key);

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  String _childUsername = '';
  bool _isLoading = false;
  List<String> _linkedChildren = [];

  @override
  void initState() {
    super.initState();
    _loadLinkedChildren();
  }

  Future<void> _loadLinkedChildren() async {
  final linkedChildrenJson = await TinyDB.getString('linked_children');
    if (linkedChildrenJson != null && linkedChildrenJson.isNotEmpty) {
      // Parse JSON or comma-separated list
      setState(() {
        _linkedChildren = linkedChildrenJson.split(',');
      });
    }
  }

  Future<void> _addChild() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if child exists in TinyDB
      final users = await TinyDB.getJson('users') ?? {};
      final childExists = users.values.any((user) => 
        (user as Map<String, dynamic>?)?['username'] == _childUsername
      );

      if (childExists) {
        final parentId = await AuthService.getCurrentUserId();
        if (parentId != null) {
          // Link child to parent in TinyDB
          if (!_linkedChildren.contains(_childUsername)) {
            _linkedChildren.add(_childUsername);
            await TinyDB.setString(
              'linked_children',
              _linkedChildren.join(','),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Successfully linked child: $_childUsername'),
              backgroundColor: Colors.green,
            ),
          );

          _formKey.currentState!.reset();
          _childUsername = '';
          setState(() {});
        } else {
          throw Exception('Parent not logged in.');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Child username not found.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeChild(String username) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Child'),
        content: Text('Remove $username from your linked children?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                final parentId = await AuthService.getCurrentUserId();
                if (parentId != null) {
                  // TODO: Implement unlinkChildFromParent in FirebaseService
                  // await FirebaseService.unlinkChildFromParent(parentId, username);

                  _linkedChildren.remove(username);
                  await TinyDB.setString(
                    'linked_children',
                    _linkedChildren.join(','),
                  );
                  setState(() {});
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Removed $username'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to remove child: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
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
          'Link Children',
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
            // Instructions
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔗 How to Link Your Child',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF388E3C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Ask your child for their username (created during signup)\n'
                      '2. Enter their username below\n'
                      '3. Click "Link Child"\n'
                      '4. You can now assign tasks to them!',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form to add child
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add a Child',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF388E3C),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter child\'s username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _childUsername = value ?? '';
                        },
                        onChanged: (value) {
                          _childUsername = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'Child\'s Username',
                          hintText: 'e.g., eco_warrior_123',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66BB6A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _addChild,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.add),
                          label: Text(
                            _isLoading ? 'Linking...' : 'Link Child',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Linked children list
            if (_linkedChildren.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Linked Children (${_linkedChildren.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _linkedChildren.length,
                    itemBuilder: (context, index) {
                      final childUsername = _linkedChildren[index];
                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF66BB6A),
                            child: Text(
                              childUsername[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            childUsername,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeChild(childUsername),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No children linked yet',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
