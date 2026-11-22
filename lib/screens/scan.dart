import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isdasmart/components/bubble_button.dart';
import 'package:isdasmart/components/button.dart';
import 'package:isdasmart/components/pill.dart';
import 'package:isdasmart/generated_assets/assets.dart';
import 'package:isdasmart/helpers.dart';
import 'package:isdasmart/main.dart';
import 'package:isdasmart/screens/fishes.dart';
import 'package:isdasmart/screens/image.dart';
import 'package:isdasmart/screens/result.dart';
import 'package:isdasmart/screens/settings.dart';
import 'package:isdasmart/theme/dark.dart';
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

  final _scanningMode = ValueNotifier<int>(0);

  final YOLOViewController _yoloViewController = YOLOViewController();
  Set<String> _labels = {};

  late PermissionStatus _cameraStatus;
  bool _isWaitingAppSettings = false;
  bool _hasRequestedCapture = false;

  bool _showToggles = false;
  bool _showOverlays = false;
  double _confidenceThreshold = .25;
  double _iouThreshold = .7;

  final fishModelPath =
      GetStorage().read<String>("fish_model_path") ?? Assets.fish;
  final freshnessModelPath =
      GetStorage().read<String>("freshness_model_path") ?? Assets.freshness;

  bool _isLoadingModel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

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
    _scanningMode.dispose();
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
    if (_scanningMode.value == 0) {
      _hasRequestedCapture = true;
    }
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

  void _onSwitchMode(int value) {
    _scanningMode.value = value;

    setState(() {
      _isLoadingModel = true;
    });

    (() async {
      await _yoloViewController.switchModel(
        value == 0 ? fishModelPath : freshnessModelPath,
      );

      setState(() {
        _isLoadingModel = false;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return Theme(
        data: darkMode,
        child: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final Widget streamView;
    if (_cameraStatus.isGranted) {
      streamView = YOLOView(
        controller: _yoloViewController,
        modelPath: Assets.fish,
        streamingConfig: YOLOStreamingConfig(
          includeOriginalImage: true,
          includeMasks: false,
          includeProcessingTimeMs: false,
          includeClassifications: false,
          includeFps: false,
          includeOBB: false,
          includePoses: false,
        ),
        onModelLoad: (modelPath, task) => setState(() {
          Fluttertoast.showToast(msg: "Loaded $modelPath");
        }),
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
              MyButton(
                onPress: _requestCameraPermission,
                text: "Request camera permission",
              ),
            if (_cameraStatus.isPermanentlyDenied)
              MyButton(onPress: _openAppSettings, text: "Open app settings"),
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.viewPaddingOf(context).top + 20,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      Hero(
                        tag: 'fishes',
                        child: MyBubbleButton(
                          onPress: () =>
                              navigatePushHero(context, FishesPage()),
                          padding: 12,
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          builder: (context, currentIndex, _) => Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(999),
                              border: BoxBorder.all(
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                            child: FlutterToggleTab(
                              dataTabs: [
                                DataTab(title: 'Identification'),
                                DataTab(title: 'Freshness'),
                              ],
                              selectedIndex: currentIndex,
                              selectedLabelIndex: _onSwitchMode,
                              isShadowEnable: false,
                              selectedBackgroundColors: [Colors.white],
                              unSelectedBackgroundColors: [Colors.transparent],
                              unSelectedTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          valueListenable: _scanningMode,
                        ),
                      ),
                      MyBubbleButton(
                        onPress: () {
                          navigatePush(context, SettingsPage());
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
            Positioned.fill(
              left: 60,
              top: 160,
              right: 60,
              bottom: 150,
              child: Image.asset(
                'assets/famicons--scan.png',
                centerSlice: Rect.fromLTRB(48, 48, 80, 80),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
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
                    color: Colors.transparent,
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
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: .25,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.12,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: Column(
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
                                                    .setConfidenceThreshold(v);
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
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyBubbleButton(
                                onPress: _pickFromGallery,
                                padding: 16,
                                child: Icon(
                                  Icons.photo_library_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              MyBubbleButton(
                                onPress: _onPressCapture,
                                padding: 20,
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              MyBubbleButton(
                                onPress: () {
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
            if (_isLoadingModel)
              Container(
                color: darkMode.scaffoldBackgroundColor.withAlpha(100),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
