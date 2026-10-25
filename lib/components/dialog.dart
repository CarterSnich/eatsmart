import 'package:flutter/material.dart';

class _BaseDialog extends StatelessWidget {
  final Widget child;
  final double innerPadding;

  const _BaseDialog({required this.child, this.innerPadding = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: BoxConstraints(maxWidth: 400, maxHeight: 260),
            padding: EdgeInsets.all(innerPadding),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: child,
          ),
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  final String? title;
  final Widget child;

  const MyDialog({super.key, required this.child, this.title});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: _BaseDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title != null)
              Text(widget.title!, textAlign: TextAlign.start),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class MyDialogPicker<T> extends StatefulWidget {
  final Map<T, String> items;
  final void Function(T item) cb;

  const MyDialogPicker({super.key, required this.items, required this.cb});

  @override
  State<MyDialogPicker<T>> createState() => _MyDialogPickerState<T>();
}

class _MyDialogPickerState<T> extends State<MyDialogPicker<T>> {
  @override
  Widget build(BuildContext context) {
    return _BaseDialog(
      innerPadding: 0,
      child: ListView(
        shrinkWrap: true,
        clipBehavior: Clip.antiAlias,
        children: List.generate(
          widget.items.length,
          (i) => InkWell(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Text(widget.items.entries.elementAt(i).value),
            ),
            onTap: () {
              widget.cb(widget.items.entries.elementAt(i).key);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
