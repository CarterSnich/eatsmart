import 'package:flutter/material.dart';

class MyNakedSection extends StatelessWidget {
  final Widget child;
  final String label;
  final double padding;

  const MyNakedSection({
    super.key,
    required this.child,
    required this.label,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Color(0xFF7DD3FC),
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(padding: EdgeInsets.all(padding), child: child),
      ],
    );
  }
}

class MySection extends StatelessWidget {
  final Widget child;
  final String? label;
  final double padding;

  const MySection({
    super.key,
    required this.child,
    this.label,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (label != null)
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Color(0xFF7DD3FC),
              fontWeight: FontWeight.bold,
            ),
          ),
        Material(
          color: Colors.white.withValues(alpha: 0.08),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Padding(padding: EdgeInsets.all(padding), child: child),
        ),
      ],
    );
  }
}

class MySectionList extends StatelessWidget {
  final List<Widget> children;
  final String? label;
  final double padding;

  const MySectionList({
    super.key,
    required this.children,
    this.label,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MySection(
      label: label,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class MySectionListItem extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPress;

  const MySectionListItem({super.key, required this.child, this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
