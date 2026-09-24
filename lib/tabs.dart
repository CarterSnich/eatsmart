import 'package:eatsmart/screens/fishes.dart';
import 'package:eatsmart/screens/home.dart';
import 'package:eatsmart/screens/scanner.dart';
import 'package:flutter/material.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({super.key});

  @override
  State<TabbedPage> createState() => _TabbedPagetate();
}

class _TabbedPagetate extends State<TabbedPage>
    with SingleTickerProviderStateMixin {
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
