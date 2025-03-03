import 'package:flutter/material.dart';
import '../models/nav_item_model.dart';

class HomeHeaderWidget extends StatelessWidget {
  final NavItem navItem;

  const HomeHeaderWidget({super.key, required this.navItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          navItem.label,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: navItem.primaryColor,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: navItem.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: navItem.primaryColor,
          ),
        ),
      ],
    );
  }
}