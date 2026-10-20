import 'package:eatsmart/screens/onboarding.dart';
import 'package:eatsmart/screens/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  // final isFirstLaunch = GetStorage().read("is_first_launch") ?? true;
  final isFirstLaunch = true;

  FlutterNativeSplash.remove();

  runApp(App(isFirstLaunch: isFirstLaunch));
}

class App extends StatelessWidget {
  const App({super.key, required this.isFirstLaunch});
  final bool isFirstLaunch;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EatSmart",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Commissioner",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Color(0xFF08111F),
      ),
      home: isFirstLaunch ? OnboardingPage() : ScanPage(),
      navigatorObservers: [routeObserver],
    );
  }
}
