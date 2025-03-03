import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'create_page.dart';
import 'explore_page.dart';
import 'homedashboard.dart';
import 'profile_page.dart';
import '../Widgets/wave_nav_bar.dart';

import '../widgets/background_pattern_painter.dart';
import '../models/nav_item_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  final List<NavItem> _navItems = [
    const NavItem(
      icon: Icons.home_rounded,
      label: 'Home',
      primaryColor: Color(0xFF6C63FF),
      secondaryColor: Color(0xFF8A84FF),
      gradientColors: [Color(0xFF6C63FF), Color(0xFF8A84FF), Color(0xFFB3B0FF)],
    ),
    const NavItem(
      icon: Icons.add_rounded,
      label: 'Create',
      primaryColor: Color(0xFF4ECDC4),
      secondaryColor: Color(0xFF7DDBD4),
      gradientColors: [Color(0xFF4ECDC4), Color(0xFF7DDBD4), Color(0xFFA9E9E4)],
    ),
    const NavItem(
      icon: Icons.explore_rounded,
      label: 'Explore',
      primaryColor: Color(0xFFFF6B6B),
      secondaryColor: Color(0xFFFF8E8E),
      gradientColors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E), Color(0xFFFFB3B3)],
    ),
    const NavItem(
      icon: Icons.chat_bubble_rounded,
      label: 'Chat',
      primaryColor: Color(0xFFFFBE0B),
      secondaryColor: Color(0xFFFFCE3B),
      gradientColors: [Color(0xFFFFBE0B), Color(0xFFFFCE3B), Color(0xFFFFDE6B)],
    ),
    const NavItem(
      icon: Icons.person_rounded,
      label: 'Profile',
      primaryColor: Color(0xFFFF006E),
      secondaryColor: Color(0xFFFF339E),
      gradientColors: [Color(0xFFFF006E), Color(0xFFFF339E), Color(0xFFFF66BE)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
    _backgroundAnimationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPatternPainter(
                color: _navItems[_selectedIndex].primaryColor,
                animation: _backgroundAnimation,
                isDark: isDark,
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _navItems.length,
            itemBuilder: (context, index) {
              if (index == 0) return HomeDashboardWidget();
              if (index == 1) return CreatePageWidget(onAddProject: () {});
              if (index == 2) return ExplorePageWidget();
              if (index == 3) return ChatPageWidget();
              if (index == 4) return ProfilePageWidget();
              return Container();
              CreatePageWidget(onAddProject: () {});
            },
          ),
        ],
      ),
      bottomNavigationBar: UltraModernNavBar(
        items: _navItems,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        },
      ),
    );
  }
}