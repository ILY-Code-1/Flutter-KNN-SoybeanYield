/// Represents a completed prediction — includes both the input features
/// and the KNN-computed [result].
class UserPredictionModel {
  final String id;
  final DateTime date;
  final double result; // KNN output (ton/ha)

  // Input features
  final double suhu;
  final double curahHujan;
  final double kelembaban;
  final double phTanah;
  final double nitrogen;
  final double fosfor;
  final double kalium;

  const UserPredictionModel({
    required this.id,
    required this.date,
    required this.result,
    required this.suhu,
    required this.curahHujan,
    required this.kelembaban,
    required this.phTanah,
    required this.nitrogen,
    required this.fosfor,
    required this.kalium,
  });
}