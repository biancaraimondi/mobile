import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);


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
        body: FlutterMap(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text("Effettua una ricerca in quest'area"),
          icon: const Icon(Icons.search),
          backgroundColor: Color(0xff30475e),
        ),
    );
  }
}

