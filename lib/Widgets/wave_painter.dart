// widgets/modern_wave_painter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ModernWavePainter extends CustomPainter {
  final Animation<double> progress;
  final int selectedIndex;
  final List<Color> colors;
  final int itemCount;

  ModernWavePainter({
    required this.progress,
    required this.selectedIndex,
    required this.colors,
    required this.itemCount,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final itemWidth = size.width / itemCount;
    final waveWidth = itemWidth * 3;
    final waveHeight = 30.0;
    final baseHeight = size.height - 20;

    // Create gradient shader
    final gradient = LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    paint.shader = gradient;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, baseHeight);

    for (double i = 0; i <= size.width + 10; i += 2) {
      final dx = i;
      final normalizedX = (dx - (selectedIndex * itemWidth)) / waveWidth;
      final progressValue = progress.value * 2 * math.pi;

      if (normalizedX >= -0.5 && normalizedX <= 1.5) {
        final fadeMultiplier = _getFadeMultiplier(normalizedX);
        final waveMultiplier = math.sin(progressValue + normalizedX * math.pi * 2) * 0.5 + 0.5;

        final y = baseHeight -
            math.sin(normalizedX * math.pi) * waveHeight * fadeMultiplier -
            waveMultiplier * 8 * fadeMultiplier;

        path.lineTo(dx, y);
      } else {
        path.lineTo(dx, baseHeight);
      }
    }

    path.lineTo(size.width, size.height);
    path.close();

    // Draw main wave with gradient
    canvas.drawPath(path, paint);

    // Add glossy effect
    final glossPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0),
        ],
        stops: const [0.0, 0.5],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, glossPaint);

    // Add subtle particle effects
    _drawParticles(canvas, size, selectedIndex * itemWidth);
  }

  double _getFadeMultiplier(double normalizedX) {
    if (normalizedX < 0) {
      return math.max(0.0, 1.0 + normalizedX * 2);
    } else if (normalizedX > 1) {
      return math.max(0.0, 2.0 - normalizedX * 2);
    }
    return 1.0;
  }

  void _drawParticles(Canvas canvas, Size size, double centerX) {
    final random = math.Random(42);
    final particlePaint = Paint()..color = Colors.white.withOpacity(0.3);

    for (int i = 0; i < 20; i++) {
      final x = centerX + (random.nextDouble() - 0.5) * 100;
      final y = size.height - 20 - random.nextDouble() * 40;
      final particleSize = 2.0 + random.nextDouble() * 2;
      final particleOpacity = (math.sin(progress.value * math.pi * 2 + i) + 1) / 2;

      particlePaint.color = Colors.white.withOpacity(0.3 * particleOpacity);
      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
    }
  }

  @override
  bool shouldRepaint(ModernWavePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.colors != colors;
  }
}