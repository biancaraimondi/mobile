import 'package:flutter/material.dart';
import 'package:mobile/navigation/saved/Position.dart';
import 'package:mobile/navigation/saved/userPOIs.dart';
import 'package:mobile/navigation/explore/map.dart';


/// Keeps the state of each tab even as you navigate through routes. This is done by creating a new navigator for each [screenWidget] given.
///
/// [screenWidgets] should be a list of Widgets where each Widget contains its own `Scaffold`.
///
/// `PersistentTabs` is commonly used with a `BottomNavigationBar` for iOS style navigation.

GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');

class PersistentTabs extends StatelessWidget {
  const PersistentTabs(
      {required this.screenWidgets, this.currentTabIndex = 0, Key? key})
      : super(key: key);
  final int? currentTabIndex;
  final List<Widget> screenWidgets;

  List<Widget> _buildOffstageWidgets() {
    return screenWidgets
        .map(
          (w) => Offstage(
        offstage: currentTabIndex != screenWidgets.indexOf(w),
        child: Navigator(
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(builder: (_) => w);
          },
        ),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildOffstageWidgets(),
    );
  }
}

// DEMO
class PersistentTabsDemo extends StatefulWidget {
  const PersistentTabsDemo({Key? key}) : super(key: key);

  @override
  _PersistentTabsDemoState createState() => _PersistentTabsDemoState();
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
        key: globalKey,
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