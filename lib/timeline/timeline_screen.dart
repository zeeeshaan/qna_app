import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qna_app/timeline/progress_section.dart';
import 'package:qna_app/timeline/project_header.dart';
import 'package:qna_app/timeline/timeline_event.dart';

class TimelineScreen extends StatefulWidget {
  final String? projectId;

  const TimelineScreen({super.key, this.projectId});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.projectId == null) {
      return const Center(child: Text('No project selected.'));
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Timeline'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No milestones found. Check Firebase.'));
          }

          final allMilestones = snapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .doc(widget.projectId)
                .collection('completedMilestones')
                .snapshots(),
            builder: (context, completedSnapshot) {
              if (completedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (completedSnapshot.hasError) {
                return Center(child: Text('Error: ${completedSnapshot.error}'));
              }

              final completedMilestones = completedSnapshot.data?.docs ?? [];

              List<TimelineEvent> events = allMilestones.map((doc) {
                final milestoneName = doc['name'];
                final isCompleted = completedMilestones.any(
                        (completed) => completed.id == milestoneName.toLowerCase().replaceAll(' ', '-'));

                return TimelineEvent(
                  title: milestoneName,
                  subtitle: '',
                  description: '',
                  icon: _getIconForCategory(milestoneName),
                  color: isCompleted ? Colors.green : Colors.blue,
                  status: isCompleted ? "Completed" : "Upcoming",
                  isExpanded: false,
                  onTap: () {
                    if (!isCompleted) {
                      _markMilestoneComplete(milestoneName);
                    }
                  },
                );
              }).toList();

              // Sort milestones in correct order
              events.sort((a, b) {
                List<String> order = ['requirements', 'ui/ux', 'development', 'testing', 'deployment'];
                return order.indexOf(a.title.toLowerCase()) - order.indexOf(b.title.toLowerCase());
              });

              double progress = events.where((e) => e.status == "Completed").length / events.length;

              return Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('projects')
                        .doc(widget.projectId)
                        .snapshots(),
                    builder: (context, projectSnapshot) {
                      if (!projectSnapshot.hasData || projectSnapshot.data == null) {
                        return const CircularProgressIndicator();
                      }

                      final projectData = projectSnapshot.data!;
                      final projectName = projectData['projectName'] ?? 'Unnamed Project';
                      final Timestamp? timestamp = projectData['createdAt'];
                      final startDate = timestamp != null
                          ? DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch).toString()
                          : 'Unknown Date';

                      return ProjectHeaderWidget(
                        projectName: projectName,
                        startDate: startDate,
                        statusLabel: "On Track",
                        statusColor: Colors.blue,
                      );
                    },
                  ),
                  ProgressSectionWidget(progress: progress),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: events.map((event) => _buildMilestoneCard(event)).toList(),
                    ),
                  ),
                  if (progress == 1.0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _markProjectComplete,
                        child: const Text('Mark as Complete'),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMilestoneCard(TimelineEvent event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(event.icon, color: event.color),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Checkbox(
          value: event.status == "Completed",
          onChanged: (checked) {
            if (checked == true) {
              _markMilestoneComplete(event.title);
            } else {
              _unmarkMilestone(event.title);
            }
          },
        ),
      ),
    );
  }

  void _markMilestoneComplete(String milestoneName) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('completedMilestones')
        .doc(milestoneName.toLowerCase().replaceAll(' ', '-'))
        .set({'completed': true});
    _updateProjectProgress();
  }

  void _unmarkMilestone(String milestoneName) async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('completedMilestones')
        .doc(milestoneName.toLowerCase().replaceAll(' ', '-'))
        .delete();
    _updateProjectProgress();
  }

  void _updateProjectProgress() async {
    final completedSnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('completedMilestones')
        .get();
    final allMilestones = await FirebaseFirestore.instance.collection('categories').get();
    double progress = completedSnapshot.docs.length / allMilestones.docs.length;
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .update({"progress": progress});
    setState(() {});
  }

  void _markProjectComplete() async {
    try {
      final projectRef = FirebaseFirestore.instance.collection('projects').doc(widget.projectId);
      final projectSnapshot = await projectRef.get();

      if (!projectSnapshot.exists) return;

      await projectRef.update({
        "status": "Completed",
        "completedAt": Timestamp.now(),
      });

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🎉 Congratulations!'),
          content: const Text('Project completed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

    } catch (e) {
      debugPrint("Error marking project as complete: $e");
    }
  }

  IconData _getIconForCategory(String category) {
    if (category.toLowerCase().contains('requirements')) return Icons.lightbulb;
    if (category.toLowerCase().contains('ui/ux')) return Icons.design_services;
    if (category.toLowerCase().contains('development')) return Icons.code;
    if (category.toLowerCase().contains('testing')) return Icons.verified;
    if (category.toLowerCase().contains('deployment')) return Icons.rocket;
    return Icons.task;
  }
}
