import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
    print('explore: $explore');
    var newMarker = Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(poi.position.latitude, poi.position.longitude),
        builder: (ctx) => const Icon(
          Icons.location_on,
          size: 45.0,
          color: Color(0xfff05454),
        )
    );
    explore.layers[1].markers.add(newMarker);
    explore.mapController.move(
        LatLng(poi.position.latitude, poi.position.longitude),
        14.0
    );
    //explore.options.onTap;

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