import 'package:eatsmart/screens/fishes.dart';
import 'package:eatsmart/screens/home.dart';
import 'package:eatsmart/screens/scanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  final _title = "EatSmart";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        fontFamily: "Istok Web",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Main(title: _title),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});
  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titles = ['Home', 'Scanner', 'Fish Library'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(_titles[_tabController.index])),
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeScreen(tabController: _tabController),
            ScannerScreen(),
            FishesScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Tab(icon: Icon(Icons.home_rounded, size: 32)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Tab(
                icon: Icon(Icons.center_focus_strong_rounded, size: 32),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Tab(icon: Icon(Icons.menu_book_rounded, size: 32)),
            ),
          ],
        ),
      ),
    );
  }
}
