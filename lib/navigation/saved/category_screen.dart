import 'package:flutter/material.dart';

import '../../models/poi.dart';
import 'poi_tile.dart';
import '../../models/position.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({required this.category, Key? key}) : super(key: key);
  final String category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String get category => widget.category;
  late List<POI> _pois;

  @override
  void initState() {
    _pois = pois.where((p) => p.type == category).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<POITile> poiTiles =
    _pois.map((p) => POITile(poi: p)).toList();
    return poiTiles.isEmpty
        ? const SizedBox.shrink()
        :
    Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(category)
      ),
      body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                itemCount: poiTiles.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, index) => poiTiles[index],
                separatorBuilder: (_, index) => const SizedBox(
                  height: 5,
                ),
              ),
            ),
          ],
    )
    );
  }
}

String areeVerdi = "Aree Verdi";
String bar = "Bar e Ristoranti";
String musei = "Musei";

List<POI> pois = [
  POI(
    id: "areeVerdi1",
    type: areeVerdi,
    position: Position(latitude: 44.4822181, longitude: 11.3526779),
    rank: 1,
  ),
  POI(
      id: "areeVerdi2",
      type: areeVerdi,
      position: Position(latitude: 44.49, longitude: 11.352677),
      rank: 2,
  ),
  POI(
      id: "bar1",
      type: bar,
      position: Position(latitude: 44.50, longitude: 11.352677),
      rank: 1,
  ),
  POI(
    id: "bar2",
    type: bar,
    position: Position(latitude: 44.51, longitude: 11.352677),
    rank: 2,
  ),
  POI(
    id: "musei1",
    type: musei,
    position: Position(latitude: 44.52, longitude: 11.352677),
    rank: 1,
  ),
  POI(
      id: "musei2",
      type: musei,
      position: Position(latitude: 44.53, longitude: 11.352677),
      rank: 2,
  )
];