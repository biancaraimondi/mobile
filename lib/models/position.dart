class Position {
  final String type;
  final List<double> coordinates;

  Position(
      {required this.type,
        required this.coordinates}
      );

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      type: json['type'],
      coordinates: [json['coordinates'].cast<double>()[1], json['coordinates'].cast<double>()[0]],
    );
  }

  @override
  String toString() {
    return 'Position{type: $type, coordinates: $coordinates}';
  }

  bool isEqualTo(Position position) {
    return type == position.type &&
        coordinates[0] == position.coordinates[0] &&
        coordinates[1] == position.coordinates[1];
  }
}
