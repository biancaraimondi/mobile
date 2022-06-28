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
}
