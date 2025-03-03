import 'package:flutter/material.dart';

enum AnimationDirection { left, right, bottom }

class HomeScreenAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final AnimationDirection direction;

  const HomeScreenAnimation({
    super.key,
    required this.child,
    this.delay = 0,
    this.direction = AnimationDirection.bottom,
  });

  @override
  State<HomeScreenAnimation> createState() => _HomeScreenAnimationState();
}

class _HomeScreenAnimationState extends State<HomeScreenAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Define initial and final offsets based on direction
    Offset beginOffset;
    switch (widget.direction) {
      case AnimationDirection.left:
        beginOffset = const Offset(-300.0, 0.0); // Slide from left
        break;
      case AnimationDirection.right:
        beginOffset = const Offset(300.0, 0.0); // Slide from right
        break;
      case AnimationDirection.bottom:
        beginOffset = const Offset(0.0, 300.0); // Slide from bottom
        break;
    }
    _offsetAnimation = Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.05), weight: 60),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 40),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value, // Use Offset animation for both X and Y
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}