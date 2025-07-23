import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Import dart:ui for FragmentProgram
import 'package:flutter/services.dart' show rootBundle;

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

class ChaosButtonState extends State<ChaosButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tapAnimation;
  late Future<ui.FragmentProgram> _shaderProgram;

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
    // Load the shader from assets
    _shaderProgram = ui.FragmentProgram.fromAsset('shaders/chaos.glsl');
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
        child: FutureBuilder<ui.FragmentProgram>(
          future: _shaderProgram,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AnimatedBuilder(
                animation: _tapAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ChaosPainter(
                      shader: snapshot.data!.fragmentShader(),
                      tapValue: _tapAnimation.value,
                      resolution: Size(widget.width, widget.height),
                      time: _controller.value,
                      lineColors: widget.lineColors,
                    ),
                    child: Container(),
                  );
                },
              );
            }
            return Container(color: widget.backgroundColor);
          },
        ),
      ),
    );
  }
}

class ChaosPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final double tapValue;
  final Size resolution;
  final double time;
  final List<Color> lineColors;

  ChaosPainter({
    required this.shader,
    required this.tapValue,
    required this.resolution,
    required this.time,
    required this.lineColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, resolution.width)
      ..setFloat(1, resolution.height)
      ..setFloat(2, time)
      ..setFloat(3, tapValue);

    // Set line colors (limited to 4 for shader compatibility)
    for (int i = 0; i < 4; i++) {
      final color = i < lineColors.length ? lineColors[i] : Colors.white;
      shader
        ..setFloat(4 + i * 3, color.red / 255.0)
        ..setFloat(5 + i * 3, color.green / 255.0)
        ..setFloat(6 + i * 3, color.blue / 255.0);
    }

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant ChaosPainter oldDelegate) {
    return oldDelegate.tapValue != tapValue ||
        oldDelegate.time != time ||
        oldDelegate.resolution != resolution ||
        oldDelegate.lineColors != lineColors;
  }
}