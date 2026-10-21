import 'dart:async';
import 'dart:io';

import 'package:eatsmart/components/bubble_button.dart';
import 'package:eatsmart/components/bubble_search_bar.dart';
import 'package:eatsmart/components/nav_button.dart';
import 'package:eatsmart/components/text_button.dart';
import 'package:eatsmart/generated_assets/assets.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/main.dart';
import 'package:eatsmart/screens/about.dart';
import 'package:eatsmart/screens/fishes.dart';
import 'package:eatsmart/screens/image.dart';
import 'package:eatsmart/screens/result.dart';
import 'package:eatsmart/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with RouteAware, WidgetsBindingObserver {
  bool _isReady = false;
  bool _showLoadingOverlay = false;

  late PermissionStatus _cameraStatus;

  final YOLOViewController _yoloViewController = YOLOViewController();

  Timer? _debounceTimer;
  int _totalFrames = 0;
  final List<String> _collectedLabels = [];
  bool _isCommitting = false;

  bool _isWaitingAppSettings = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _initCameraStatus();
    _yoloViewController.setShowOverlays(false);
  }

  @override
  void didPushNext() {
    _yoloViewController.pause();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    _isCommitting = false;
    _yoloViewController.resume();
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getCameraStatus();
      setState(() {
        _isWaitingAppSettings = false;
      });
    }
  }

  @override
  void dispose() {
    _yoloViewController.stop();
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initCameraStatus() async {
    final status = await _getCameraStatus();
    if (!status.isGranted) {
      await _requestCameraPermission();
    }
    setState(() {
      _isReady = true;
    });
  }

  Future<PermissionStatus> _getCameraStatus() async {
    final status = await Permission.camera.status;
    setState(() {
      _cameraStatus = status;
    });

    return status;
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraStatus = status;
    });
  }

  Future<void> _openAppSettings() async {
    if (!_isWaitingAppSettings) {
      setState(() {
        _isWaitingAppSettings = true;
      });
      await openAppSettings();
    }
  }

  void _onModelError(Object error, String modelPath, YOLOTask? task) {
    Fluttertoast.showToast(msg: "${error.toString()}: $modelPath");
  }

  void _onStreamingData(Map<String, dynamic> data) {
    final detections = data['detections'] as List? ?? [];

    final highConfidence = detections
        .where(
          (r) =>
              r['confidence'] >= 0.5 &&
              (r['className'] != 'other' || r['background']),
        )
        .map((r) => r['className'] as String)
        .toList();

    if (highConfidence.isEmpty) return;

    _totalFrames++;
    _collectedLabels.addAll(highConfidence);

    if (_debounceTimer == null || _isCommitting) {
      _debounceTimer = Timer(
        const Duration(seconds: 5),
        () => _commitDetections(data['originalImage']),
      );
      _showLoadingOverlay = true;

      setState(() {});
    }
  }

  void _commitDetections(Uint8List finalFrame) {
    if (_isCommitting) return;

    final Map<String, int> labelCounts = {};

    for (final label in _collectedLabels) {
      labelCounts[label] = (labelCounts[label] ?? 0) + 1;
    }

    final confirmedLabels = labelCounts.entries
        .where((entry) => entry.value / _totalFrames >= 0.3)
        .map((entry) => entry.key)
        .toList();

    _isCommitting = true;
    _debounceTimer = null;
    setState(() {});

    _pushResultPage(confirmedLabels, finalFrame);
  }

  void _pushResultPage(List<String> labels, Uint8List image) {
    navigatePush(context, ResultPage(labels: labels, image: image), () {
      setState(() {
        _showLoadingOverlay = false;
      });
    });
  }

  Future<void> _pickFromGallery() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      _pushDetectionPage(File(imageFile.path));
    }
  }

  void _pushDetectionPage(File imageFile) {
    navigatePush(context, ImageDetectPage(imageFile: imageFile));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Widget streamView;
    if (_cameraStatus.isGranted) {
      streamView = YOLOView(
        controller: _yoloViewController,
        modelPath: Assets.model,
        streamingConfig: YOLOStreamingConfig(
          includeOriginalImage: true,
          includeMasks: false,
          includeProcessingTimeMs: false,
          includeClassifications: false,
          includeFps: false,
          includeOBB: false,
          includePoses: false,
        ),
        // onResult: _onResult,
        onStreamingData: _onStreamingData,
        onModelError: _onModelError,
      );
    } else {
      streamView = Align(
        alignment: AlignmentGeometry.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text("Please allow camera access to use the scanner."),
            if (_cameraStatus.isDenied)
              MyTextButton(
                onPress: _requestCameraPermission,
                text: "Request camera permission",
              ),
            if (_cameraStatus.isPermanentlyDenied)
              MyTextButton(
                onPress: _openAppSettings,
                text: "Open app settings",
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          streamView,
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(100, 0, 0, 0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.viewPaddingOf(context).top + 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'fishes',
                            child: MyBubbleSearchBar(
                              onTap: () {
                                navigatePushHero(context, FishesPage());
                              },
                              child: Text(
                                'Search fish',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        MyBubbleButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            );
                          },
                          padding: 12,
                          child: Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Wrap(children: []),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(100, 0, 0, 0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyBubbleButton(
                          onPressed: _pickFromGallery,
                          padding: 16,
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        MyBubbleButton(
                          onPressed: _pickFromGallery,
                          padding: 20,
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        MyBubbleButton(
                          onPressed: _pickFromGallery,
                          padding: 16,
                          child: Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showLoadingOverlay)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: SpinKitFadingGrid(color: Colors.white, size: 50.0),
              ),
            ),
        ],
      ),
    );
  }
}
