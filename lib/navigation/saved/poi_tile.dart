import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:mobile/navigation/user_navigation_bar.dart';
import 'package:mobile/models/poi.dart';
import 'package:mobile/navigation/explore/map.dart';
import 'package:mobile/navigation/explore/popup.dart';
import 'package:mobile/globals.dart' as globals;

import 'package:http/http.dart' as http;

class POITile extends StatefulWidget {
  const POITile({required this.poi, Key? key}) : super(key: key);
  final POI poi;

  @override
  State<POITile> createState() => _POITileState();
}

class _POITileState extends State<POITile> {

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

    final dynamic bottomBar = bottomBarKey.currentWidget;
    bottomBar.onTap(0);
  }

  bool _isFavorited = true;

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  void removeFromSaved() async {
      final response = await http
          .post(
        Uri.parse('http://localhost:3001/me/poi/remove'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "username": globals.getUsername(),
          "poi": {
            "type": poi.type,
            "position": {
              "latitude": poi.position.coordinates[0],
              "longitude": poi.position.coordinates[1]
            },
            "rank": poi.rank,
            "id": poi.id
          }
        }),
      );

      if (!(response.statusCode >= 200 && response.statusCode < 300)) {
        throw Exception('Failed to call http request');
      }
  }

  void addToSaved() async {
    final response = await http
        .post(
      Uri.parse('http://localhost:3001/me/poi/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": globals.getUsername(),
        "poi": {
          "type": poi.type,
          "position": {
            "latitude": poi.position.coordinates[0],
            "longitude": poi.position.coordinates[1]
          },
          "rank": poi.rank,
          "id": poi.id
        }
      }),
    );

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw Exception('Failed to call http request');
    }
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
            onPressed: () =>
            {
              if (_isFavorited){
                removeFromSaved()
              } else {
                addToSaved()
              },
              _toggleFavorite()
            },
            icon: _isFavorited
                ? Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary)
                : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.secondary)
          ),
        ),
    );
  }
}