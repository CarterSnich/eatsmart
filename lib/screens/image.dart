import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isdasmart/generated_assets/assets.dart';
import 'package:isdasmart/helpers.dart';
import 'package:isdasmart/screens/result.dart';

class ImageDetectPage extends StatefulWidget {
  final File imageFile;

  const ImageDetectPage({super.key, required this.imageFile});

  @override
  State<ImageDetectPage> createState() => _ImageDetectPageState();
}

class _ImageDetectPageState extends State<ImageDetectPage> {
  File get _imageFile => widget.imageFile;

  bool _isReady = false;
  List<String> _labels = [];
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();

    (() async {
      final yolo = await initYolo(Assets.fish);
      final imageBytes = await _imageFile.readAsBytes();
      final labels = await predict(yolo, imageBytes);

      if (labels.isEmpty) {
        Fluttertoast.showToast(msg: "No fish detected or fish unknown.");
      }

      setState(() {
        _labels = labels;
        _imageBytes = imageBytes;
        _isReady = true;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (_isReady) {
      return Scaffold(
        body: ResultPage(labels: _labels, imageBytes: _imageBytes),
      );
    } else {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }
  }
}
