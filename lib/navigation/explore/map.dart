import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

GlobalKey exploreKey = GlobalKey<NavigatorState>();

enum CategoryValues { areeVerdi, bar, musei }
enum PrivacyValues { dummyUpdate, GPSPerturbation, noPrivacy}

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  double _currentRankValue = 5;
  CategoryValues? _currentCategoryValue = CategoryValues.areeVerdi;
  PrivacyValues? _currentPrivacyValue = PrivacyValues.noPrivacy;
  bool _isDummy = false;
  bool _isGPS = false;
  int? _currentPrivacyNumber;

  List<Marker> setMarkers(){
    Marker markerTest = Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(44.4938203, 11.3426327),
          builder: (ctx) => Icon(
            Icons.location_on,
            size: 45.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
    );

    List<Marker> markers = [markerTest];

    //TODO richiesta di markers al server
    //markers.add(markers[0]);

    return markers;
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
                  zoom: 13.5,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']
                  ),
                  MarkerLayerOptions(
                      markers: setMarkers()
                  )
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
                                        title: const Text('Aree Verdi'),
                                        leading: Radio<CategoryValues>(
                                          value: CategoryValues.areeVerdi,
                                          groupValue: _currentCategoryValue,
                                          onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Bar e Ristoranti'),
                                        leading: Radio<CategoryValues>(
                                          value: CategoryValues.bar,
                                          groupValue: _currentCategoryValue,
                                          onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Musei'),
                                        leading: Radio<CategoryValues>(
                                        value: CategoryValues.musei,
                                        groupValue: _currentCategoryValue,
                                        onChanged: (CategoryValues? value) {
                                            state(() {
                                              _currentCategoryValue = value;
                                            });
                                          },
                                        ),
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
                                                value: PrivacyValues.dummyUpdate,
                                                groupValue: _currentPrivacyValue,
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
                                                value: PrivacyValues.GPSPerturbation,
                                                groupValue: _currentPrivacyValue,
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
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
                                                    _isDummy = false;
                                                    _isGPS = false;
                                                  });
                                                },
                                              ),
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
              )
            ],
          )
    );
  }
}

