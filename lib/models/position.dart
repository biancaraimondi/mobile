class Position {
  final double latitude;
  final double longitude;

  Position(
      {required this.longitude,
        required this.latitude}
      );

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
