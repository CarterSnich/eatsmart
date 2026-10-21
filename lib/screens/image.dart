import 'dart:io';

import 'package:eatsmart/generated_assets/assets.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/screens/result.dart';
import 'package:flutter/material.dart';

class ImageDetectPage extends StatefulWidget {
  final File imageFile;

  const ImageDetectPage({super.key, required this.imageFile});

  @override
  State<ImageDetectPage> createState() => _ImageDetectPageState();
}

class _ImageDetectPageState extends State<ImageDetectPage> {
  bool _isReady = false;
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();

    (() async {
      final yolo = await initYolo(Assets.model);
      final labels = await predict(yolo, await widget.imageFile.readAsBytes());

      setState(() {
        _labels = labels;
        _isReady = true;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return Scaffold(
        body: ResultPage(
          labels: _labels,
          image: widget.imageFile.readAsBytesSync(),
        ),
      );
    } else {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }
  }
}
