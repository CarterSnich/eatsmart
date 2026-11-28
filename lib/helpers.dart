import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> navigatePush(
  BuildContext context,
  Widget screen, [
  VoidCallback? cb,
]) async {
  final route = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => screen),
  );
  cb?.call();
  return route;
}

String formatPercentage(double n, int precision) {
  return "${(n * 100).toStringAsFixed(precision)}%";
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

Future<List<String>> predict(
  YOLO model,
  Uint8List imageBytes, {
  double confidenceThreshold = 0.25,
  double ioutThreshold = 0.7,
}) async {
  final results = await model.predict(
    imageBytes,
    confidenceThreshold: confidenceThreshold,
    iouThreshold: ioutThreshold,
  );

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

void showNotifBar(BuildContext context) {
  final isLight = Theme.of(context).brightness == Brightness.light;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
    ),
  );
}

Future<void> storageWrite(String key, dynamic value) async {
  await GetStorage().write(key, value);
}

T storageRead<T>(String key, T fallback) {
  return GetStorage().read<T>(key) ?? fallback;
}

Future<void> openLink(String url) async {
  final uri = Uri.parse(url);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok) {
    Fluttertoast.showToast(msg: "Couldn't open link");
  }
}
