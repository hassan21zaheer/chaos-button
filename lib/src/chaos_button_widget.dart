import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChaosButton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<Color> lineColors;
  final Duration animationDuration;
  final VoidCallback? onTap;

  const ChaosButton({
    super.key,
    this.width = 200.0,
    this.height = 60.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    this.backgroundColor = Colors.black,
    this.lineColors = const [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ],
    this.animationDuration = const Duration(milliseconds: 300),
    this.onTap,
  });

  @override
  ChaosButtonState createState() => ChaosButtonState();
}

class ChaosButtonState extends State<ChaosButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _tapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
        ),
        child: AnimatedBuilder(
          animation: _tapAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: ChaosPainter(
                tapValue: _tapAnimation.value,
                resolution: Size(widget.width, widget.height),
                time: _controller.value *
                    widget.animationDuration.inMilliseconds /
                    1000.0,
                lineColors: widget.lineColors,
              ),
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}

class ChaosPainter extends CustomPainter {
  final double tapValue;
  final Size resolution;
  final double time;
  final List<Color> lineColors;

  ChaosPainter({
    required this.tapValue,
    required this.resolution,
    required this.time,
    required this.lineColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Consistent seed for reproducible chaos
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

// Draw multiple sets of lines to mimic shader complexity
    for (int set = 0; set < 2; set++) {
// Two sets: thicker lines (like shader's first loop) and thinner lines (like second loop)
      final lineCount = set == 0 ? 20 : 40; // More lines in second set
      final maxThickness = set == 0 ? 2.0 : 0.5;
      final amplitude = set == 0 ? 20.0 : 10.0;

      for (int i = 0; i < lineCount; i++) {
// Select color based on index
        final colorIndex = i % 4;
        final color = colorIndex < lineColors.length
            ? lineColors[colorIndex]
            : Colors.white;
        paint
          ..color = color.withOpacity(tapValue * 0.8) // Fade with tap animation
          ..strokeWidth = maxThickness * (0.5 + random.nextDouble() * 0.5);

// Generate chaotic line path
        final y = i * size.height / lineCount;
        final points = <Offset>[];
        for (double x = 0; x <= size.width; x += 2.0) {
// Simulate noise with sine and random variation
          final noise = math.sin(x * 0.05 + time * 0.1 + i) * amplitude +
              random.nextDouble() * amplitude * 0.5;
          points.add(Offset(x, y + noise));
        }

// Draw line segments
        for (int j = 0; j < points.length - 1; j++) {
          canvas.drawLine(points[j], points[j + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ChaosPainter oldDelegate) {
    return oldDelegate.tapValue != tapValue ||
        oldDelegate.time != time ||
        oldDelegate.resolution != resolution ||
        oldDelegate.lineColors != lineColors;
  }
}
