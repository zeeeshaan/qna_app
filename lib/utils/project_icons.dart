// **Function to Assign Icons Based on Project Name**
import 'package:flutter/material.dart';

IconData getProjectIcon(String projectName) {
  if (projectName.toLowerCase().contains('tracking')) {
    return Icons.location_on; // Location tracking project
  } else if (projectName.toLowerCase().contains('app')) {
    return Icons.smartphone; // App development project
  } else if (projectName.toLowerCase().contains('website')) {
    return Icons.web; // Website project
  } else if (projectName.toLowerCase().contains('finance')) {
    return Icons.attach_money; // Finance-related project
  } else if (projectName.toLowerCase().contains('ai')) {
    return Icons.memory; // AI-related project
  } else {
    return Icons.folder; // Default project icon
  }
}

// **Function to Assign Colors Based on Project Name**
Color getProjectColor(String projectName) {
  if (projectName.toLowerCase().contains('tracking')) {
    return Colors.blue; // Tracking projects → Blue
  } else if (projectName.toLowerCase().contains('app')) {
    return Colors.green; // App projects → Green
  } else if (projectName.toLowerCase().contains('website')) {
    return Colors.orange; // Website projects → Orange
  } else if (projectName.toLowerCase().contains('finance')) {
    return Colors.purple; // Finance projects → Purple
  } else if (projectName.toLowerCase().contains('ai')) {
    return Colors.red; // AI projects → Red
  } else {
    return Colors.grey; // Default color
  }
}

