import 'package:flutter/material.dart';

class MyBubbleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPress;
  final double padding;

  const MyBubbleButton({
    super.key,
    required this.child,
    required this.onPress,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPress,
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      ),
    );
  }
}
