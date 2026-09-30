import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double radius;
  final Widget child;
  final double padding;
  final Color? bgColor;
  final double borderWidth;

  const MyCard({
    super.key,
    this.radius = 8.0,
    required this.child,
    this.padding = 0,
    this.bgColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? Colors.white.withValues(alpha: 0.08),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.white.withValues(alpha: 0.12),
          width: borderWidth,
        ),
      ),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
