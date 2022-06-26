import 'package:flutter/material.dart';
import 'package:mobile/navigation/saved/user_pois.dart';
import 'package:mobile/navigation/explore/map.dart';

import '../route_generator.dart';

GlobalKey bottomBarKey = GlobalKey<NavigatorState>();

class PersistentTabs extends StatelessWidget {
  const PersistentTabs(
      {required this.screenWidgets, this.currentTabIndex = 0, Key? key})
      : super(key: key);
  final int? currentTabIndex;
  final List<Widget> screenWidgets;

  List<Widget> _buildOffstageWidgets(context) {
    return screenWidgets
        .map(
          (w) => Offstage(
        offstage: currentTabIndex != screenWidgets.indexOf(w),
        child: Navigator(
        initialRoute: w is Explore?'/explore':'/saved',
        onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildOffstageWidgets(context),
    );
  }
}

// DEMO
class PersistentTabsDemo extends StatefulWidget {
  const PersistentTabsDemo({Key? key}) : super(key: key);

  @override
  State<PersistentTabsDemo> createState() => _PersistentTabsDemoState();
}

class _PersistentTabsDemoState extends State<PersistentTabsDemo> {
  int? currentTabIndex;

  @override
  void initState() {
    super.initState();
    currentTabIndex = 0;
  }

  void setCurrentIndex(int val) {
    setState(() {
      currentTabIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabs(
        currentTabIndex: currentTabIndex,
        screenWidgets: const [Explore(), UserPOIs()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomBarKey,
        onTap: setCurrentIndex,
        currentIndex: currentTabIndex!,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Saved",
          ),
        ],
      ),
    );
  }
}