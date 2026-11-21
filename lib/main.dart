import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isdasmart/screens/onboarding.dart';
import 'package:isdasmart/screens/scan.dart';
import 'package:isdasmart/theme/dark.dart';
import 'package:isdasmart/theme/light.dart';
import 'package:isdasmart/theme/provider.dart';
import 'package:provider/provider.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await GetStorage.init();
  final bool isFirstLaunch = GetStorage().read("is_first_launch") ?? true;
  final ThemeMode themeMode = switch (GetStorage().read<int>("theme_mode")) {
    1 => ThemeMode.light,
    2 => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  FlutterNativeSplash.remove();

  runApp(App(isFirstLaunch: isFirstLaunch, themeMode: themeMode));
}

class App extends StatelessWidget {
  final bool isFirstLaunch;
  final ThemeMode themeMode;

  const App({super.key, required this.isFirstLaunch, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(themeMode: themeMode),
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: "IsdaSmart",
          themeMode: theme.themeMode,
          theme: lightMode,
          darkTheme: darkMode,
          home: isFirstLaunch ? OnboardingPage() : ScanPage(),
          navigatorObservers: [routeObserver],
        ),
      ),
    );
  }
}
