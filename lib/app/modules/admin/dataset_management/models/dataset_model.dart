class DatasetModel {
  final String id;
  final double suhu;
  final double curahHujan;
  final double kelembaban;
  final double phTanah;
  final double nitrogen;
  final double fosfor;
  final double kalium;
  final double hasilPanen;

  const DatasetModel({
    required this.id,
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
