import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory DatasetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DatasetModel(
      id: doc.id,
      suhu: (data['suhu'] as num).toDouble(),
      curahHujan: (data['curah_hujan'] as num).toDouble(),
      kelembaban: (data['kelembaban'] as num).toDouble(),
      phTanah: (data['ph_tanah'] as num).toDouble(),
      nitrogen: (data['nitrogen'] as num).toDouble(),
      fosfor: (data['fosfor'] as num).toDouble(),
      kalium: (data['kalium'] as num).toDouble(),
      hasilPanen: (data['hasil_panen'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'suhu': suhu,
        'curah_hujan': curahHujan,
        'kelembaban': kelembaban,
        'ph_tanah': phTanah,
        'nitrogen': nitrogen,
        'fosfor': fosfor,
        'kalium': kalium,
        'hasil_panen': hasilPanen,
      };
}
