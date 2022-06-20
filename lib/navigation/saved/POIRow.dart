import 'package:flutter/material.dart';

import 'POI.dart';
import 'POITile.dart';

class POIRow extends StatelessWidget {
  const POIRow(
      {required this.pois, Key? key})
      : super(key: key);
  final List<POI> pois;

  @override
  Widget build(BuildContext context) {
    List<POITile> _poiTiles =
    pois.map((p) => POITile(poi: p)).toList();

    return _poiTiles.isEmpty
        ? const SizedBox.shrink()
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 205,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: _poiTiles.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => _poiTiles[index],
            separatorBuilder: (_, index) => const SizedBox(
              width: 24,
            ),
          ),
        ),
      ],
    );
  }
}