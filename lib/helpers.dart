import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/yolo.dart';

Future<dynamic> navigatePush(BuildContext context, Widget screen) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

Future<dynamic> navigatePushHero(BuildContext context, Widget screen) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, _, _) => screen,
      transitionDuration: Duration(milliseconds: 500),
      reverseTransitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (_, a, _, c) => FadeTransition(opacity: a, child: c),
    ),
  );
}

Future<YOLO> initYolo(String modelPath) async {
  final yolo = YOLO(modelPath: modelPath);
  await yolo.loadModel();
  return yolo;
}

Future<List<String>> predict(YOLO model, Uint8List imageBytes) async {
  final results = await model.predict(imageBytes);

  if (results['detections'].isEmpty) {
    return [];
  }

  final detections = results['detections'] as List? ?? [];
  final labels = detections
      .where((r) => r['className'] != 'background' && r['className'] != 'other')
      .map((r) => r['className'] as String)
      .toSet()
      .toList();

  return labels;
}
