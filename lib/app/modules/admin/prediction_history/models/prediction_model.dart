class PredictionModel {
  final String id;
  final DateTime date;
  final String username;
  final double result;
  final double suhu;
  final double curahHujan;
  final double phTanah;
  final double nitrogen;
  final double fosfor;
  final double kalium;

  const PredictionModel({
    required this.id,
    required this.date,
    required this.username,
    required this.result,
    required this.suhu,
    required this.curahHujan,
    required this.phTanah,
    required this.nitrogen,
    required this.fosfor,
    required this.kalium,
  });
}
