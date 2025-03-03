import 'package:flutter/material.dart';
import '../models/nav_item_model.dart';

class DefaultContentWidget extends StatelessWidget {
  final NavItem navItem;

  const DefaultContentWidget({super.key, required this.navItem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: navItem.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Icon(
          navItem.icon,
          size: 64,
          color: Colors.white,
        ),
      ),
    );
  }
}