import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qna_app/View/totalproject_screen.dart';

class HomeDashboardWidget extends StatelessWidget {
  const HomeDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Dashboard',
          style: TextStyle(color: Colors.white, fontFamily: 'Lora'),
        ),
        backgroundColor: Colors.blueAccent.shade400,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade100, Colors.white],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('projects')
                .snapshots(),
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
              final totalProjects = projects.length;
              final completedProjects = projects
                  .where((doc) => doc['status'] == 'Completed')
                  .length;
              final inProgressProjects = projects
                  .where((doc) => doc['status'] == 'In Progress')
                  .length;
              final upcomingProjects = totalProjects - completedProjects -
                  inProgressProjects;

              return Padding(
                padding: const EdgeInsets.only(top: 40, left: 19, right: 19),
                child: Column(
                  children: [
                    buildAnimatedCard(
                        context, 'Total Projects', totalProjects, Icons.work,
                        Colors.blue, null),
                    buildAnimatedCard(context, 'Completed', completedProjects,
                        Icons.check_circle, Colors.green, 'Completed'),
                    buildAnimatedCard(
                        context, 'In Progress', inProgressProjects,
                        Icons.hourglass_bottom, Colors.orange, 'In Progress'),
                    buildAnimatedCard(
                        context, 'Upcoming', upcomingProjects, Icons.event,
                        Colors.purple, 'Upcoming'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedCard(BuildContext context, String title, int count,
      IconData icon, Color color, String? status) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProjectsListScreen(title: title, status: status),
          ),
        );
      },
      child: AnimatedContainer(
        duration: 600.ms,
        curve: Curves.easeInOut,
        height: 120,
        width: 320,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 15, spreadRadius: 3)
          ],
          border: Border.all(color: color.withOpacity(0.6), width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 25,
              child: Icon(icon, size: 30, color: color),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora')),
                Text('$count', style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: 'Lora')),
              ],
            ),
          ],
        ),
      ).animate().fade(duration: 600.ms).scale(),
    );
  }
}
