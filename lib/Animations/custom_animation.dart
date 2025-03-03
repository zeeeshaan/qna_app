import 'package:flutter/material.dart';

class CustomTextAnimation extends StatefulWidget {
  final String text;
  final AnimationController controller;

  const CustomTextAnimation({
    super.key,
    required this.text,
    required this.controller,
  });

  @override
  State<CustomTextAnimation> createState() => _CustomTextAnimationState();
}

class _CustomTextAnimationState extends State<CustomTextAnimation> {
  late Animation<double> _blurAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeIn),
    );

    _offsetAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnimation.value),
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
                    color: Colors.blue.withOpacity(0.6 * _fadeAnimation.value),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}