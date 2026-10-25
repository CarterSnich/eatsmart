import 'dart:async';
import 'dart:io';

import 'package:eatsmart/components/bubble_button.dart';
import 'package:eatsmart/components/bubble_search_bar.dart';
import 'package:eatsmart/components/pill.dart';
import 'package:eatsmart/components/text_button.dart';
import 'package:eatsmart/generated_assets/assets.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/main.dart';
import 'package:eatsmart/screens/fishes.dart';
import 'package:eatsmart/screens/image.dart';
import 'package:eatsmart/screens/result.dart';
import 'package:eatsmart/screens/settings.dart';
import 'package:eatsmart/theme/dark.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late PermissionStatus _cameraStatus;
  final YOLOViewController _yoloViewController = YOLOViewController();
  Set<String> _labels = {};
  bool _isWaitingAppSettings = false;
  bool _hasRequestedCapture = false;

  bool _showToggles = false;
  bool _showOverlays = false;
  double _confidenceThreshold = .25;
  double _iouThreshold = .7;

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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.didPushNext();
  }

  @override
  void didPopNext() {
    _yoloViewController.resume();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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

    final detectedLabels = detections
        .where(
          (r) => (r['className'] != 'other' || r['background'] == 'background'),
        )
        .map((r) => r['className'] as String)
        .toSet();

    if (_hasRequestedCapture) {
      _hasRequestedCapture = false;

      if (detectedLabels.isEmpty) {
        Fluttertoast.showToast(msg: "No fish detected.");
      } else {
        _pushResultsPage(detectedLabels, data['originalImage']);
      }
    } else {
      setState(() {
        _labels = detectedLabels;
      });
    }
  }

  void _onPressCapture() {
    _hasRequestedCapture = true;
  }

  void _pickFromGallery() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile != null) {
      _pushDetectionPage(File(imageFile.path));
    }
  }

  void _pushResultsPage(Set<String> labels, Uint8List imageBytes) {
    navigatePush(
      context,
      ResultPage(
        labels: labels.toList(),
        imageBytes: imageBytes,
        imageRotation: 1,
      ),
    );
  }

  void _pushDetectionPage(File imageFile) {
    navigatePush(context, ImageDetectPage(imageFile: imageFile));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Theme(
        data: ThemeData.dark(useMaterial3: true),
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
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
        confidenceThreshold: _confidenceThreshold,
        iouThreshold: _iouThreshold,
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

    return Theme(
      data: darkMode,
      child: Scaffold(
        body: Stack(
          children: [
            streamView,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: List.generate(
                            _labels.length,
                            (i) => MyPill(
                              backgroundColor: Colors.white,
                              child: Text(
                                _labels.elementAt(i).toUpperCase(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(100, 0, 0, 0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            spacing: _showToggles ? 16 : 0,
                            children: [
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear,
                                alignment: Alignment.bottomCenter,
                                child: _showToggles
                                    ? Column(
                                        spacing: 8,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Show overlays"),
                                              Switch(
                                                value: _showOverlays,
                                                onChanged: (value) {
                                                  _yoloViewController
                                                      .setShowOverlays(value);
                                                  setState(() {
                                                    _showOverlays = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Confidence threshold: ${formatPercentage(_yoloViewController.confidenceThreshold, 0)}",
                                              ),
                                              Slider(
                                                value: _confidenceThreshold,
                                                max: 1,
                                                min: 0,
                                                divisions: 100,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8,
                                                ),
                                                onChanged: (v) {
                                                  _yoloViewController
                                                      .setConfidenceThreshold(
                                                        v,
                                                      );
                                                  setState(() {
                                                    _confidenceThreshold = v;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "IoU threshold: ${formatPercentage(_yoloViewController.iouThreshold, 0)}",
                                              ),
                                              Slider(
                                                value: _iouThreshold,
                                                max: 1,
                                                min: 0,
                                                divisions: 100,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 8,
                                                ),
                                                onChanged: (v) {
                                                  _yoloViewController
                                                      .setIoUThreshold(v);
                                                  setState(() {
                                                    _iouThreshold = v;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    onPressed: _onPressCapture,
                                    padding: 20,
                                    child: Icon(
                                      Icons.camera,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  MyBubbleButton(
                                    onPressed: () {
                                      setState(() {
                                        _showToggles = !_showToggles;
                                      });
                                    },
                                    padding: 16,
                                    child: Icon(
                                      Icons.tune,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
