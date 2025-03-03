import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onInfoPressed;

  const AppBarWidget({
    super.key,
    this.onBackPressed,
    this.onFilterPressed,
    this.onInfoPressed,
    required LinearGradient gradient,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: onBackPressed,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.black87),
          onPressed: onFilterPressed,
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.black87),
          onPressed: onInfoPressed,
        ),
      ],
      title: const Text(
        'Project Timeline',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          fontFamily: 'Lora'
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}