import 'package:flutter/material.dart';
import 'package:qna_app/timeline/status_chip.dart';

class ProjectHeaderWidget extends StatelessWidget {
  final String projectName;
  final String startDate;
  final String statusLabel;
  final Color statusColor;

  const ProjectHeaderWidget({
    super.key,
    required this.projectName,
    required this.startDate,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Started: $startDate',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          StatusChipWidget(label: statusLabel, color: statusColor),
        ],
      ),
    );
  }
}