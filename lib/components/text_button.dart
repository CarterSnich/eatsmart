import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final VoidCallback onPress;
  final String text;

  const MyTextButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
