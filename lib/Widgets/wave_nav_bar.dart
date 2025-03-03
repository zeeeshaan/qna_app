// widgets/ultra_modern_nav_bar.dart
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../models/nav_item_model.dart';
import 'wave_painter.dart';


class UltraModernNavBar extends StatefulWidget {
  final List<NavItem> items;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const UltraModernNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<UltraModernNavBar> createState() => _UltraModernNavBarState();
}

class _UltraModernNavBarState extends State<UltraModernNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late AnimationController _floatingController;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotateAnimations;
  late List<Animation<double>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
          (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
      );
    }).toList();

    _rotateAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 0.1).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
      );
    }).toList();

    _slideAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 8.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _floatingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UltraModernNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _animationControllers[widget.selectedIndex].forward().then((_) {
        _animationControllers[widget.selectedIndex].reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 80,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withOpacity(0.8)
              : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: widget.items[widget.selectedIndex].primaryColor
                  .withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: CustomPaint(
              painter: ModernWavePainter(
                progress: _floatingController,
                selectedIndex: widget.selectedIndex,
                colors: widget.items[widget.selectedIndex].gradientColors,
                itemCount: widget.items.length,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(widget.items.length, (index) {
                  return _buildNavItem(index, isDark);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, bool isDark) {
    final item = widget.items[index];
    final isSelected = index == widget.selectedIndex;

    return GestureDetector(
      onTap: () => widget.onItemSelected(index),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleAnimations[index],
          _rotateAnimations[index],
          _slideAnimations[index],
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_slideAnimations[index].value),
            child: Transform.rotate(
              angle: _rotateAnimations[index].value,
              child: Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: isSelected
                              ? item.gradientColors
                              : [
                            isDark
                                ? Colors.white54
                                : Colors.black54,
                            isDark
                                ? Colors.white54
                                : Colors.black54,
                          ],
                        ).createShader(bounds),
                        child: Icon(
                          item.icon,
                          size: 26,
                          color: Colors.white,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isSelected ? 4 : 0,
                        child: Text(
                          isSelected ? item.label : '',
                          style: TextStyle(
                            color: item.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}