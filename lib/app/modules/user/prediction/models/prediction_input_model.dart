/// Holds the raw form inputs before KNN prediction is computed.
class PredictionInputModel {
  final double suhu;
  final double curahHujan;
  final double kelembaban;
  final double phTanah;
  final double nitrogen;
  final double fosfor;
  final double kalium;
  final double hasilPanen; // user-supplied reference / label field

  const PredictionInputModel({
    required this.suhu,
    required this.curahHujan,
    required this.kelembaban,
    required this.phTanah,
    required this.nitrogen,
    required this.fosfor,
    required this.kalium,
    required this.hasilPanen,
  });
}