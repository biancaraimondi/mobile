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
    id: 1,
    name: "Area Verde 1",
    position: Position(type: "Point", coordinates: [44.4822181, 11.3526779]),
    type: "green_area",
    rank: 1,
  ),
  POI(
    id: 2,
    name: "Area Verde 2",
    position: Position(type: "Point", coordinates: [44.49, 11.3526779]),
    type: "green_area",
    rank: 2,
  ),
  POI(
    id: 3,
    name: "Bar 1",
    position: Position(type: "Point", coordinates: [44.50, 11.3526779]),
    type: "bar",
    rank: 1,
  ),
  POI(
    id: 4,
    name: "Bar 2",
    position: Position(type: "Point", coordinates: [44.51, 11.3526779]),
    type: "bar",
    rank: 2,
  ),
  POI(
    id: 5,
    name: "Museo 1",
    position: Position(type: "Point", coordinates: [44.52, 11.3526779]),
    type: "museum",
    rank: 1,
  ),
  POI(
    id: 6,
    name: "Museo 2",
    position: Position(type: "Point", coordinates: [44.53, 11.3526779]),
    type: "museum",
    rank: 2,
  )
];