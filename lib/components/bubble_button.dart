import 'package:flutter/material.dart';

class MyBubbleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double padding;

  const MyBubbleButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}
