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
                  color: Colors.red,
              ),
        ),
    ));
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
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
    );
  }
}

