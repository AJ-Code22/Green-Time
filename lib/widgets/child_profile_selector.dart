import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/child_profile.dart';
import '../services/tinydb_service.dart';

class ChildProfileSelector extends StatefulWidget {
  final Function(String selectedUsername) onChildSelected;
  final String? initialSelectedUsername;

  const ChildProfileSelector({
    Key? key,
    required this.onChildSelected,
    this.initialSelectedUsername,
  }) : super(key: key);

  @override
  State<ChildProfileSelector> createState() => _ChildProfileSelectorState();
}

class _ChildProfileSelectorState extends State<ChildProfileSelector> {
  List<String> _linkedChildren = [];
  String? _selectedUsername;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedUsername = widget.initialSelectedUsername;
    _loadLinkedChildren();
  }

  Future<void> _loadLinkedChildren() async {
    try {
  final linkedChildrenJson = await TinyDB.getString('linked_children');
      setState(() {
        if (linkedChildrenJson != null && linkedChildrenJson.isNotEmpty) {
          _linkedChildren = linkedChildrenJson.split(',');
          _selectedUsername ??= _linkedChildren.isNotEmpty ? _linkedChildren.first : null;
        }
        _isLoading = false;
      });
      
      if (_selectedUsername != null) {
        widget.onChildSelected(_selectedUsername!);
      }
    } catch (e) {
      print('Error loading linked children: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_linkedChildren.isEmpty) {
      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No children linked yet',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Link your children by their usernames to get started',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _linkedChildren.length,
        itemBuilder: (context, index) {
          final username = _linkedChildren[index];
          final isSelected = _selectedUsername == username;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == _linkedChildren.length - 1 ? 0 : 8,
            ),
            child: _ChildProfileCard(
              username: username,
              isSelected: isSelected,
              onTap: () {
                setState(() => _selectedUsername = username);
                widget.onChildSelected(username);
              },
            ),
          );
        },
      ),
    );
  }
}

class _ChildProfileCard extends StatelessWidget {
  final String username;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChildProfileCard({
    required this.username,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF66BB6A) : Colors.grey[300]!,
            width: isSelected ? 3 : 2,
          ),
          color: isSelected ? const Color(0xFF66BB6A).withOpacity(0.1) : Colors.white,
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFF66BB6A).withOpacity(0.3), blurRadius: 8)]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF66BB6A),
              child: Text(
                username[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Username
            Expanded(
              child: Center(
                child: Text(
                  username,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C3E50),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Selected indicator
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Selected',
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
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
