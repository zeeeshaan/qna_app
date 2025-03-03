import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../timeline/timeline_screen.dart';

class ExplorePageWidget extends StatelessWidget {
  const ExplorePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('projects').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No projects yet.'));
        }

        final projects = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            final projectName = project['projectName'] as String? ?? 'Unnamed Project';
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(projectName, style: const TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimelineScreen(projectId: project.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}