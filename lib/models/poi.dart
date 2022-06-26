import 'package:mobile/models/position.dart';

class POI {
  final String id;
  final String type;
  final Position position;
  final int rank;

  const POI(
      {required this.id,
        required this.type,
        required this.position,
        required this.rank});

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
      id: json['id'],
      type: json['type'],
      position: json['position'],
      rank: json['rank'],
    );
  }
}