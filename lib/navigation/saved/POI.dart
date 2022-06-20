import 'Position.dart';

class POI {
  final String id;
  /// Which overall category this product belongs in. e.g - areeVerdi, bar, musei, etc
  final String type;
  final Position position;
  final int rank;

  POI(
      {required this.id,
        required this.type,
        required this.position,
        required this.rank});
}