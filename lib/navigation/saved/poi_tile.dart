import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'dart:developer' as developer;
import 'package:mobile/navigation/user_navigation_bar.dart';
import '../../models/poi.dart';
import '../explore/map.dart';
import '../explore/popup.dart';

class POITile extends StatefulWidget {
  const POITile({required this.poi, Key? key}) : super(key: key);
  final POI poi;

  @override
  State<POITile> createState() => _POITileState();
}

class _POITileState extends State<POITile> {
  //POITile({required this.poi, Key? key}) : super(key: key);

  POI get poi => widget.poi;

  void _pushScreen() {

    Color color;
    switch (poi.type){
      case "historical building":
        color = Colors.blue;
        break;
      case "park":
        color = Colors.green;
        break;
      case "theater":
        color = Colors.red;
        break;
      case "museum":
        color = Colors.deepPurple;
        break;
      case "department":
        color = Colors.amber;
        break;
      default:
        color = Theme.of(context).colorScheme.secondary;
    }
    //add the poi as a marker to the map
    final dynamic explore = exploreKey.currentWidget;

    var marker = Marker(
      width: 45.0,
      height: 45.0,
      point: LatLng(poi.position.coordinates[0], poi.position.coordinates[1]),
      builder: (context) => IconButton(
        onPressed: (){
          ShowMoreTextPopup popup = ShowMoreTextPopup(context,
            text: poi.name,
            height: 75,
            width: 300,
            textStyle: const TextStyle(color: Colors.black),
            backgroundColor: Colors.white,
            poi: poi,
          );

          popup.show(
            rect: Rect.fromLTWH(
              MediaQuery.of(context).size.width / 2 - 100,
              MediaQuery.of(context).size.height / 2 - 50,
              200,
              200,
            ),
          );
        },
        icon: Icon(
          Icons.location_on,
          size: 45.0,
          color: color,
        ),
      ),
    );

    if (!explore.layers[1].markers.contains(marker)) {
      explore.layers[1].markers.add(marker);
    }

    explore.mapController.move(
        LatLng(poi.position.coordinates[0], poi.position.coordinates[1]),
        15.5
    );

    //show the map section
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
            child: Text(poi.name),
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