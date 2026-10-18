import 'package:flutter/material.dart';

class MyAnimatedCircles extends StatefulWidget {
  const MyAnimatedCircles({super.key});

  @override
  State<MyAnimatedCircles> createState() => _MyAnimatedCirclesState();
}

class _MyAnimatedCirclesState extends State<MyAnimatedCircles>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double scale(double start, double end, double t) {
    if (t < start || t > end) return 1;

    final progress = (t - start) / (end - start);

    return 1 +
        0.15 *
            Curves.easeInOut.transform(
              progress < 0.5 ? progress * 2 : (1 - progress) * 2,
            );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        final t = controller.value;

        return SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer
              Transform.scale(
                scale: scale(0.43, 1.0, t),
                child: _circle(240, Colors.blue.shade900, 0.18),
              ),

              // Middle
              Transform.scale(
                scale: scale(0.21, 0.78, t),
                child: _circle(204, Colors.blue.shade700, 0.12),
              ),

              // Inner
              Transform.scale(
                scale: scale(0.0, 0.56, t),
                child: _circle(136, Colors.blue, 0.08),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}
