import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../timeline/timeline_screen.dart';
import '../utils/project_icons.dart';

class ProjectsListScreen extends StatelessWidget {
  final String title;
  final String? status;

  const ProjectsListScreen({super.key, required this.title, this.status});

  @override
  Widget build(BuildContext context) {
    // **MediaQuery for Responsive Sizing**
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05, // Responsive font size
          ),
        ),
        backgroundColor: Colors.blueAccent.shade400,
      ),
      body: Stack(
        children: [
          // **Gradient Background**
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueAccent, Colors.white],
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
                return const Center(child: Text('No projects found.'));
              }

              final allProjects = snapshot.data!.docs;
              final filteredProjects = status == null
                  ? allProjects
                  : allProjects.where((doc) => doc['status'] == status)
                  .toList();

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  // Responsive horizontal padding
                  vertical: screenHeight * 0.02, // Responsive vertical padding
                ),
                child: ListView.builder(
                  itemCount: filteredProjects.length,
                  itemBuilder: (context, index) {
                    var project = filteredProjects[index];
                    var projectData = project.data() as Map<String, dynamic>;
                    String projectName = projectData.containsKey('projectName')
                        ? projectData['projectName']
                        : 'Unknown';

                    // **Assign Icon & Color Based on Project Name**
                    IconData projectIcon = getProjectIcon(projectName);
                    Color iconColor = getProjectColor(projectName);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimelineScreen(projectId: project.id),
                          ),
                        );
                      },

                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015), // More space
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          // Light background
                          borderRadius: BorderRadius.circular(screenWidth * 0.09),
                          // **Rounded Corners**
                          border: Border.all(color: iconColor, width: 2),
                          // Border color based on icon color
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: screenWidth * 0.03,
                              spreadRadius: screenWidth * 0.005,
                              offset: Offset(
                                  screenWidth * 0.02, screenHeight * 0.015),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(screenWidth * 0.04),
                          leading: CircleAvatar(
                            radius: screenWidth * 0.06, // Responsive icon size
                            backgroundColor: iconColor.withOpacity(0.2),
                            child: Icon(projectIcon, color: iconColor,
                                size: screenWidth * 0.07),
                          ),
                          title: Text(
                            projectName,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              // Responsive text size
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lora',
                            ),
                          ),
                          subtitle: Text(
                            projectData.containsKey('status')
                                ? "Status: ${projectData['status']}"
                                : "Status: Unknown",
                            style: TextStyle(color: Colors.teal.shade700,
                                fontSize: screenWidth * 0.035),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
