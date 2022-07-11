import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

import 'package:mobile/navigation/explore/popup.dart';
import 'package:mobile/models/poi.dart';
import 'package:mobile/models/position.dart';

GlobalKey exploreKey = GlobalKey<NavigatorState>();

enum CategoryValues { historicalBuilding, park, theater, museum, department }
extension ParseToStringCategory on CategoryValues {
  String toShortString() {
    return toString().split('.').last;
  }
}
enum PrivacyValues { dummy, perturbation, noPrivacy}
extension ParseToStringPrivacy on PrivacyValues {
  String toShortString() {
    return toString().split('.').last;
  }
}

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  double _currentRankValue = 0;
  CategoryValues? _currentCategoryValue;
  PrivacyValues? _currentPrivacyValue;
  bool _isDummy = false;
  bool _isGPS = false;
  int? _currentPrivacyNumber;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  List<Marker> _markers = [];
  late double _zoom;
  bool popupShown = false;

  @override
  void initState() {
    super.initState();

    getLocation();
    setAllMarkers();
    _zoom = 13.5;
  }

  Future<void> getLocation() async {
    Location location = Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {

      _markers.removeWhere((marker) =>
        marker.builder == (context) => Icon(
          Icons.my_location_rounded,
          size: 25.0,
          color: Theme.of(context).colorScheme.primary,
        )
      );

      _locationData = currentLocation;

      var latitude = _locationData.latitude;
      var longitude = _locationData.longitude;
      var userPositionMarker = Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(latitude!, longitude!),
        builder: (context) => Icon(
            Icons.my_location_rounded,
            size: 25.0,
            color: Theme.of(context).colorScheme.primary,
          ),
      );
      _markers.add(userPositionMarker);

      final dynamic explore = exploreKey.currentWidget;
      explore.mapController.move(
          LatLng(latitude, longitude),
          13.5
      );
      _zoom = 13.5;
    });

    location.enableBackgroundMode(enable: true);
  }

  void setAllMarkers() async {
    final response = await http
        .get(
      Uri.parse('http://localhost:3001/poi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final pois = await jsonDecode(response.body);
      List<POI> poiList = [];
      for (var poi in pois) {
        poiList.add(POI.fromJson(poi));
      }
      return setMarkers(poiList, false);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw Exception('Failed to get pois');
    } else {
      throw Exception('Failed to call http request');
    }
  }

  void setFilteredMarkers() async {
    getLocation();
    var category = _currentCategoryValue?.toShortString() as String;
    if (category == "hystoricalBuilding") {
      category = "hystorical building";
    }
    var privacy = _currentPrivacyValue?.toShortString() as String;
    dynamic response;
    if (privacy == "noPrivacy") {
      response = await http
          .post(
        Uri.parse('http://localhost:3001/poi/optimal'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "minRank": _currentRankValue,
          "type": category,
          "positions": [
            {
              "latitude": _locationData.latitude,
              "longitude": _locationData.longitude
            },
          ]
        }),
      );
    } else {
      response = await http
          .post(
        Uri.parse('http://localhost:3002/privacy'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
                  "position": [
                    _locationData.latitude,
                    _locationData.longitude
                  ],
                  "privacy": privacy,
                  "minRank": _currentRankValue,
                  "type": category,
                  "dummyOrPerturbationDigits": _currentPrivacyNumber
              }),
      );
    }

    if (await response.statusCode >= 200 && await response.statusCode < 300) {
      final pois = await jsonDecode(response.body);
      dynamic rightPoi;
      for (var poi in pois['items']) {
        if (poi['position']['latitude'] == _locationData.latitude && poi['position']['longitude'] == _locationData.longitude) {
          rightPoi = poi['poi'];
        }
      }

      List<POI> poiList = [
        POI(
          id: 1,
          name: rightPoi['name'],
          position: Position(
              type: 'Point',
              coordinates: [
                rightPoi['position']['latitude'],
                rightPoi['position']['longitude']
              ]),
          type: rightPoi['type'],
          rank: rightPoi['rank']
        )
      ];
      return setMarkers(poiList, true);
    } else if (await response.statusCode >= 400 && await response.statusCode < 500) {
      throw Exception('Failed to get pois');
    } else {
      throw Exception('Failed to call http request');
    }
  }

  void setMarkers(List<POI> pois, bool withFilters) async {
    //historicalBuilding, park, theater, museum, department

    for (var poi in pois) {
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
              final dynamic explore = exploreKey.currentWidget;
              explore.mapController.move(
                  LatLng(poi.position.coordinates[0], poi.position.coordinates[1]),
                  15.5
              );
              _zoom = 15.5;
            },
            icon: Icon(
              Icons.location_on,
              size: 45.0,
              color: color,
            ),
          ),
      );

      if (!_markers.contains(marker)) {
        _markers.add(marker);
      }


      if (withFilters) {
        final dynamic explore = exploreKey.currentWidget;
        explore.mapController.move(
            LatLng(marker.point.latitude, marker.point.longitude),
            15.5
        );
        _zoom = 15.5;
      } else {
        final dynamic explore = exploreKey.currentWidget;
        explore.mapController.move(
            LatLng(44.4988203, 11.3426327),
            13.5
        );
        _zoom = 13.5;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          child: Stack(
            children: <Widget>[
              FlutterMap(
                key: exploreKey,
                options: MapOptions(
                  center: LatLng(44.4938203, 11.3426327),
                  zoom: _zoom,
                  maxZoom: 18,
                  minZoom: 13,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']
                  ),
                  MarkerLayerOptions(
                      markers: _markers
                  ),
                ],
                mapController: MapController(),
              ),
              Align(
                alignment: const FractionalOffset(0.05, 0.07),
                child: FloatingActionButton.extended(
                  heroTag: "rank",
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: const Text('Seleziona il rank'),
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (context, state) => Center(
                                  child: Slider(
                                    value: _currentRankValue,
                                    min: 0,
                                    max: 10,
                                    divisions: 10,
                                    label: _currentRankValue.round().toString(),
                                    onChanged: (val) {
                                      state(() {
                                        _currentRankValue = val;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                    );
                  },
                  label: const Text("Rank", style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.45, 0.07),
                child: FloatingActionButton.extended(
                  heroTag: "categoria",
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: const Text('Seleziona la categoria'),
                            children: <Widget>[
                              StatefulBuilder(
                                builder: (context, state) => Center(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Edificio Storico'),
                                        leading: Radio<CategoryValues>(
                                          value: CategoryValues.historicalBuilding,
                                          groupValue: _currentCategoryValue,
                                          toggleable: true,
                                          activeColor: Theme.of(context).colorScheme.secondary,
                                          onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Parco'),
                                        leading: Radio<CategoryValues>(
                                          value: CategoryValues.park,
                                          groupValue: _currentCategoryValue,
                                          toggleable: true,
                                          activeColor: Theme.of(context).colorScheme.secondary,
                                          onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Teatro'),
                                        leading: Radio<CategoryValues>(
                                            value: CategoryValues.theater,
                                            groupValue: _currentCategoryValue,
                                            toggleable: true,
                                            activeColor: Theme.of(context).colorScheme.secondary,
                                            onChanged: (CategoryValues? value) {
                                                state(() {
                                                    _currentCategoryValue = value;
                                                });
                                            },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Museo'),
                                        leading: Radio<CategoryValues>(
                                        value: CategoryValues.museum,
                                        groupValue: _currentCategoryValue,
                                        toggleable: true,
                                        activeColor: Theme.of(context).colorScheme.secondary,
                                        onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Dipartimento'),
                                        leading: Radio<CategoryValues>(
                                          value: CategoryValues.department,
                                          groupValue: _currentCategoryValue,
                                          toggleable: true,
                                          activeColor: Theme.of(context).colorScheme.secondary,
                                          onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      )
                                    ],
                                  )
                                )
                              )
                            ]
                          );
                        }
                    );
                  },
                  label: const Text("Categoria", style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Align(
                alignment:  const FractionalOffset(0.95, 0.07),
                child: FloatingActionButton.extended(
                  heroTag: "privacy",
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                              title: const Text('Seleziona la privacy'),
                              children: <Widget>[
                                StatefulBuilder(
                                    builder: (context, state) => Center(
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              title: const Text('Dummy Update'),
                                              leading: Radio<PrivacyValues>(
                                                value: PrivacyValues.dummy,
                                                groupValue: _currentPrivacyValue,
                                                toggleable: true,
                                                activeColor: Theme.of(context).colorScheme.secondary,
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
                                                    _isDummy = true;
                                                    _isGPS = false;
                                                  });
                                                },
                                              ),
                                            ),
                                            if (_isDummy)
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.digitsOnly
                                                    ],
                                                    onChanged: (text) {
                                                      _currentPrivacyNumber = int.parse(text);
                                                    },
                                                    decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Numero di dummy update',
                                                    ),
                                                  )
                                              ),
                                            ListTile(
                                              title: const Text('GPS Perturbation'),
                                              leading: Radio<PrivacyValues>(
                                                value: PrivacyValues.perturbation,
                                                groupValue: _currentPrivacyValue,
                                                toggleable: true,
                                                activeColor: Theme.of(context).colorScheme.secondary,
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
                                                    _isDummy = false;
                                                    _isGPS = true;
                                                  });
                                                },
                                              ),
                                            ),
                                            if (_isGPS)
                                              Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.digitsOnly
                                                    ],
                                                    onChanged: (text) {
                                                      _currentPrivacyNumber = int.parse(text);
                                                    },
                                                    decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Numero di perturbation digits',
                                                    ),
                                                  )
                                              ),
                                            ListTile(
                                              title: const Text('No Privacy'),
                                              leading: Radio<PrivacyValues>(
                                                value: PrivacyValues.noPrivacy,
                                                groupValue: _currentPrivacyValue,
                                                toggleable: true,
                                                activeColor: Theme.of(context).colorScheme.secondary,
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
                                                    _isDummy = false;
                                                    _isGPS = false;
                                                  });
                                                },
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () => Navigator.pop(context, 'OK'),
                                                child: const Text('OK'),
                                            ),
                                          ],
                                        )
                                    )
                                )
                              ]
                          );
                        }
                    );
                  },
                  label: const Text("Privacy", style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.95, 0.98),
                child: FloatingActionButton.extended(
                  heroTag: "search",
                  onPressed: () {
                    if (_currentCategoryValue == null || _currentPrivacyValue == null
                        || (_currentPrivacyValue != PrivacyValues.noPrivacy && _currentPrivacyNumber == null)) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Attenzione'),
                            content: const Text('Non hai selezionato tutti i filtri per la ricerca del POI ottimale'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          )
                      );
                    } else {
                      setFilteredMarkers();
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text("Cerca", style: TextStyle(color: Colors.white)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.05, 0.88),
                child: FloatingActionButton(
                  heroTag: "zoom_out",
                  onPressed: () {
                    if (_zoom > 13) {
                      final dynamic explore = exploreKey.currentWidget;
                      explore.mapController.move(
                          LatLng(_markers[0].point.latitude,
                              _markers[0].point.longitude),
                          --_zoom
                      );
                    }
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.remove),
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.05, 0.98),
                child: FloatingActionButton(
                  heroTag: "zoom_in",
                  onPressed: () {
                    if (_zoom < 18) {
                      final dynamic explore = exploreKey.currentWidget;
                      explore.mapController.move(
                          LatLng(_markers[0].point.latitude,
                              _markers[0].point.longitude),
                          ++_zoom
                      );
                    }
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          )
    );
  }
}