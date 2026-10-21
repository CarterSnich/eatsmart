import 'dart:typed_data';

import 'package:eatsmart/components/fish_card.dart';
import 'package:eatsmart/data/fish_data.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final List<String> labels;
  final Uint8List image;

  const ResultPage({super.key, required this.labels, required this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double _dragPosition = 0.5;
  late double _sheetPosition = _dragPosition;
  final minChildSize = 0.25;
  final maxChildSize = 1.0;

  List<String> get _labels => widget.labels;
  Uint8List get _image => widget.image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double viewHeight = constraints.maxHeight;

          return Column(
            children: [
              Expanded(child: Image.memory(_image, fit: BoxFit.contain)),
              Expanded(
                child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: _sheetPosition,
                  minChildSize: minChildSize,
                  maxChildSize: maxChildSize,
                  builder: (context, scrollController) {
                    return ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Grabber(
                            onVerticalDragUpdate: (details) {
                              setState(() {
                                _dragPosition -= details.delta.dy / viewHeight;
                                _sheetPosition = _dragPosition.clamp(
                                  minChildSize,
                                  maxChildSize,
                                );
                              });
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(10),
                              itemCount: _labels.length,
                              itemBuilder: (context, i) => MyFishCard(
                                fish: fishes[_labels[i]] as FishData,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Grabber extends StatelessWidget {
  const Grabber({super.key, required this.onVerticalDragUpdate});

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: colorScheme.onSurface,
        child: Align(
          alignment: .topCenter,
          child: Container(
            margin: const .symmetric(vertical: 8.0),
            width: 32.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: .circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
