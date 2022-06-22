import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

enum CategoryValues { areeVerdi, bar, musei }
enum PrivacyValues { dummyUpdate, GPSPerturbation, noPrivacy}

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  double _currentRankValue = 5;
  CategoryValues? _currentCategoryValue = CategoryValues.areeVerdi;
  PrivacyValues? _currentPrivacyValue = PrivacyValues.noPrivacy;

   List<Marker> setMarkers(){
    List<Marker> markers = [];

    markers.add(Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng(44.4938203, 11.3426327),
        builder: (ctx) => Container(
              child: const Icon(
                  Icons.location_on,
                  size: 45.0,
                  color: Color(0xff30475e),
              ),
        ),
    ));
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Select assignment'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {  },
                            child: const Text('Treasury department'),
                          ),
                          SimpleDialogOption(
                            onPressed: () { },
                            child: const Text('State department'),
                          ),
                        ],
                      );
                    }
                );
              },
              child: const Text('Rank', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Categoria', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Privacy', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
         */
        body: SizedBox(
          child: Stack(
            children: <Widget>[
              FlutterMap(
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
              ),
              Align(
                alignment: const FractionalOffset(0.05, 0.07),
                child: FloatingActionButton.extended(
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
                                        //debugPrint('movieTitle: $val');
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
                  //icon: const Icon(Icons.more_vert),
                  backgroundColor: const Color(0xff30475e),
                ),
              ),
              Align(
                alignment: const FractionalOffset(0.45, 0.07),
                child: FloatingActionButton.extended(
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
                  //icon: const Icon(Icons.more_vert),
                  backgroundColor: const Color(0xff30475e),
                ),
              ),
              Align(
                alignment:  const FractionalOffset(0.95, 0.07),
                child: FloatingActionButton.extended(
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
                                              title: const Text('Dummy Update'),
                                              leading: Radio<PrivacyValues>(
                                                value: PrivacyValues.dummyUpdate,
                                                groupValue: _currentPrivacyValue,
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('GPS Perturbation'),
                                              leading: Radio<PrivacyValues>(
                                                value: PrivacyValues.GPSPerturbation,
                                                groupValue: _currentPrivacyValue,
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('No Privacy'),
                                              leading: Radio<PrivacyValues>(
                                                value: PrivacyValues.noPrivacy,
                                                groupValue: _currentPrivacyValue,
                                                onChanged: (PrivacyValues? value) {
                                                  state(() {
                                                    _currentPrivacyValue = value;
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
                  label: const Text("Privacy", style: TextStyle(color: Colors.white)),
                  //icon: const Icon(Icons.more_vert),
                  backgroundColor: const Color(0xff30475e),
                ),
              ),
              /*Align(
                alignment:  const FractionalOffset(0.45, 0.99),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: const Text("Effettua una ricerca in quest'area", style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.search),
                  backgroundColor: const Color(0xff30475e),
                ),
              ),*/
            ],
          )
        )

        /*
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text("Effettua una ricerca in quest'area"),
          icon: const Icon(Icons.search),
          backgroundColor: Color(0xff30475e),
        ),
         */
    );
  }
}

