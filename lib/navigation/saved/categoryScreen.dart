import 'package:flutter/material.dart';

import 'POI.dart';
import 'POITile.dart';
import 'Position.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({required this.category, Key? key}) : super(key: key);
  final String category;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
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
    List<POITile> _poiTiles =
    _pois.map((p) => POITile(poi: p)).toList();
    return _poiTiles.isEmpty
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
              width: 205,
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 18),
                itemCount: _poiTiles.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (_, index) => _poiTiles[index],
                separatorBuilder: (_, index) => const SizedBox(
                  height: 24,
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
    position: Position(44.4822181, 11.3526779),
    rank: 1,
  ),
  POI(
      id: "areeVerdi2",
      type: areeVerdi,
      position: Position(44.4822181, 11.352677),
      rank: 2,
  ),
  POI(
      id: "bar1",
      type: bar,
      position: Position(44.4822181, 11.352677),
      rank: 1,
  ),
  POI(
    id: "bar2",
    type: bar,
    position: Position(44.4822181, 11.352677),
    rank: 2,
  ),
  POI(
    id: "musei1",
    type: musei,
    position: Position(44.4822181, 11.352677),
    rank: 1,
  ),
  POI(
      id: "musei2",
      type: musei,
      position: Position(44.4822181, 11.352677),
      rank: 2,
  )
];