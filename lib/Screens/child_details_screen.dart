import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hi/services/firebase_service.dart';
import 'package:hi/Models/task.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChildDetailsScreen extends StatelessWidget {
  final String childId;

  const ChildDetailsScreen({Key? key, required this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Details', style: GoogleFonts.poppins(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseService.getUserProfileStream(childId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }
          if (!userSnapshot.hasData) {
            return const Center(child: Text('User not found.'));
          }

          final user = userSnapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'], style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Tasks', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                StreamBuilder(
                  stream: FirebaseService.getTasksStream(childId),
                  builder: (context, taskSnapshot) {
                    if (taskSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (taskSnapshot.hasError) {
                      return Center(child: Text('Error: ${taskSnapshot.error}'));
                    }
                    if (!taskSnapshot.hasData || taskSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No tasks found.'));
                    }

                    final tasks = taskSnapshot.data!.docs.map((doc) => Task.fromDocument(doc)).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(task.description, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
                                const SizedBox(height: 8),
                                Text('Points: ${task.points}', style: GoogleFonts.poppins(fontSize: 14, color: Colors.green)),
                                if (task.proofPhotoURL != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Proof Photo:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 5),
                                        CachedNetworkImage(
                                          imageUrl: task.proofPhotoURL!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (task.completedAt != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Completed: ${task.completedAt!.toLocal().toString().split(' ')[0]}',
                                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
