import 'package:eatsmart/onboarding.dart';
import 'package:eatsmart/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

  FlutterNativeSplash.remove();

  runApp(App(isFirstLaunch: isFirstLaunch));
}

class App extends StatelessWidget {
  const App({super.key, required this.isFirstLaunch});
  final bool isFirstLaunch;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EatSmart",
      theme: ThemeData(
        fontFamily: "Istok Web",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: isFirstLaunch ? OnboardingPage() : TabbedPage(),
    );
  }
}
