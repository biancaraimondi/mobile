import 'package:flutter/material.dart';

import 'package:mobile/navigation/userNavigationBar.dart';
import '../../main.dart';
import '../../models/POI.dart';

class POITile extends StatefulWidget {
  const POITile({required this.poi, Key? key}) : super(key: key);
  final POI poi;

  @override
  _POITileState createState() => _POITileState();
}

class _POITileState extends State<POITile> {
  //POITile({required this.poi, Key? key}) : super(key: key);

  POI get poi => widget.poi;

  void _pushScreen() {
    final dynamic explore = exploreKey.currentWidget;
    print(explore);
    //explore.markers([poi]);
    final dynamic bottomBar = bottomBarKey.currentWidget;
    bottomBar.onTap(0);

  }

  bool _isFavorited = true;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: GestureDetector(
            onTap: () => _pushScreen(),
            child: Icon(Icons.location_pin, color: Theme.of(context).colorScheme.secondary),
          ),
          title: GestureDetector(
            onTap: () => _pushScreen(),
            child: Text(poi.id),
          ),
          subtitle: GestureDetector(
            onTap: () => _pushScreen(),
            child: Text('Rank: ${poi.rank}'),
          ),
          trailing: IconButton(
            onPressed: () => _toggleFavorite(),
            icon: _isFavorited
                ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary)
                : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.secondary)
          ),
        ),
    );
  }
}