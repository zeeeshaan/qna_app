import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Color> gradientColors;

  const NavItem({
    required this.icon,
    required this.label,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gradientColors,
  });
}