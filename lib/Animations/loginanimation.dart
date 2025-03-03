import 'package:flutter/material.dart';

class LoginCustomTextAnimation extends StatefulWidget {
  final String text;

  const LoginCustomTextAnimation({super.key, required this.text});

  @override
  State<LoginCustomTextAnimation> createState() => _LoginCustomTextAnimationState();
}

class _LoginCustomTextAnimationState extends State<LoginCustomTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _offsetAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _offsetAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.1), weight: 70),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 30),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
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
          offset: Offset(0, _offsetAnimation.value),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: _blurAnimation.value,
                      color: Colors.red.withOpacity(0.4 * _fadeAnimation.value),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}