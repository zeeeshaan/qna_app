// widgets/background_pattern_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundPatternPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;
  final bool isDark;

  BackgroundPatternPainter({
    required this.color,
    required this.animation,
    required this.isDark,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Create a subtle grid pattern
    const gridSize = 40.0;
    const dotSize = 3.0;

    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        final wave = math.sin(animation.value * math.pi * 2 + (x + y) / 100);
        final scale = 0.5 + wave * 0.5;

        canvas.drawCircle(
          Offset(x, y),
          dotSize * scale,
          paint,
        );
      }
    }

    // Add floating shapes
    _drawFloatingShapes(canvas, size, paint);
  }

  void _drawFloatingShapes(Canvas canvas, Size size, Paint paint) {
    final random = math.Random(42);
    final shapePaint = Paint()
      ..color = color.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final shapeSize = 20.0 + random.nextDouble() * 40;
      final rotation = random.nextDouble() * math.pi * 2;
      final wave = math.sin(animation.value * math.pi * 2 + i);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation + wave * 0.1);

      if (i % 3 == 0) {
        // Draw circle
        canvas.drawCircle(Offset.zero, shapeSize * (0.8 + wave * 0.2), shapePaint);
      } else if (i % 3 == 1) {
        // Draw square
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: shapeSize * (0.8 + wave * 0.2),
            height: shapeSize * (0.8 + wave * 0.2),
          ),
          shapePaint,
        );
      } else {
        // Draw triangle
        final path = Path();
        final triangleSize = shapeSize * (0.8 + wave * 0.2);
        path.moveTo(0, -triangleSize / 2);
        path.lineTo(triangleSize / 2, triangleSize / 2);
        path.lineTo(-triangleSize / 2, triangleSize / 2);
        path.close();
        canvas.drawPath(path, shapePaint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.animation != animation ||
        oldDelegate.isDark != isDark;
  }
}