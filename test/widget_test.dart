// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For cartersnich, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isdasmart/data/fish_data.dart';
import 'package:isdasmart/models/fish.dart';
import 'package:isdasmart/screens/about.dart';
import 'package:isdasmart/screens/fish.dart';
import 'package:isdasmart/screens/fishes.dart';
import 'package:isdasmart/screens/image.dart';
import 'package:isdasmart/screens/onboarding.dart';
import 'package:isdasmart/screens/scan.dart';
import 'package:isdasmart/screens/settings.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProvider extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => './test';
}

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = MockPathProvider();
    await GetStorage.init();
  });

  group("Test screens:", () {
    testWidgets('OnboardingPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));
      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });

    testWidgets('ScanPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(const MaterialApp(home: ScanPage()));
      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });

    testWidgets('ImageDetectPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(
        MaterialApp(
          home: ImageDetectPage(
            imageFile: File("c:\\Users\\LovaRM\\Downloads\\banugs.jpg"),
          ),
        ),
      );

      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });

    testWidgets('FishesPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(const MaterialApp(home: FishesPage()));

      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });

    testWidgets('FishPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        MaterialApp(home: FishPage(fish: fishes['bangus'] as FishData)),
      );

      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });

    testWidgets('AboutPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const MaterialApp(home: AboutPage()));

      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });

    testWidgets('SettingsPage renders', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      stopwatch.stop();
      print('${stopwatch.elapsedMilliseconds} ms');
    });
  });
}
