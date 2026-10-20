import 'dart:io';

import 'package:eatsmart/components/pill.dart';
import 'package:eatsmart/data/fish_data.dart';
import 'package:eatsmart/generated_assets/assets.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:eatsmart/screens/fish.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageDetectPage extends StatefulWidget {
  final File imageFile;

  const ImageDetectPage({super.key, required this.imageFile});

  @override
  State<ImageDetectPage> createState() => _ImageDetectPageState();
}

class _ImageDetectPageState extends State<ImageDetectPage> {
  bool _isReady = false;
  List<String> _labels = [];

  void pop() {
    Navigator.pop(context);
  }

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
    return Scaffold(
      body: _isReady
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(widget.imageFile),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 8,
                    children: List.generate(
                      _labels.length,
                      (index) => MyPill(
                        child: Text(
                          _labels[index],
                          style: TextStyle(fontSize: 16),
                        ),
                        onPress: () {
                          FishData? fish = fishes[_labels[index]];

                          if (fish == null) {
                            Fluttertoast.showToast(msg: "Fish unknown.");
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FishPage(fish: fish),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
