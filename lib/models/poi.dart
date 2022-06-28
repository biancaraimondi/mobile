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
}