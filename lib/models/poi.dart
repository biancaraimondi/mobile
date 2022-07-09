import 'dart:convert';

import 'package:mobile/models/position.dart';

class POI {
  final int id;
  final String name;
  final Position position;
  final String type;
  final int rank;

  const POI(
      {required this.id,
        required this.name,
        required this.position,
        required this.type,
        required this.rank});

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
      id: json['id'],
      name: json['name'],
      position: Position.fromJson(json['position']),
      type: json['type'],
      rank: json['rank'],
    );
  }

  bool isEqualTo(POI poi) {
    return id == poi.id &&
        name == poi.name &&
        position.isEqualTo(poi.position) &&
        type == poi.type &&
        rank == poi.rank;
  }

  @override
  String toString() {
    return 'POI{id: $id, name: $name, position: ${position.toString()}, type: $type, rank: $rank}';
  }
}