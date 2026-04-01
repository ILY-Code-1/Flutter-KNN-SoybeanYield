import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionModel {
  final String id;
  final DateTime date;
  final String username;
  final String userId;
  final double result;
  final double? actualYield;

  // Input features
  final double suhu;
  final double curahHujan;
  final double kelembaban;
  final double phTanah;
  final double nitrogen;
  final double fosfor;
  final double kalium;

  const PredictionModel({
    required this.id,
    required this.date,
    required this.username,
    required this.userId,
    required this.result,
    required this.suhu,
    required this.curahHujan,
    required this.kelembaban,
    required this.phTanah,
    required this.nitrogen,
    required this.fosfor,
    required this.kalium,
    this.actualYield,
  });

  factory PredictionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PredictionModel(
      id: doc.id,
      date: (data['timestamp'] as Timestamp).toDate(),
      username: data['username'] as String? ?? '',
      userId: data['user_id'] as String? ?? '',
      result: (data['result'] as num).toDouble(),
      suhu: (data['suhu'] as num).toDouble(),
      curahHujan: (data['curah_hujan'] as num).toDouble(),
      kelembaban: (data['kelembaban'] as num).toDouble(),
      phTanah: (data['ph_tanah'] as num).toDouble(),
      nitrogen: (data['nitrogen'] as num).toDouble(),
      fosfor: (data['fosfor'] as num).toDouble(),
      kalium: (data['kalium'] as num).toDouble(),
      actualYield: data['actual_yield'] != null
          ? (data['actual_yield'] as num).toDouble()
          : null,
    );
  }
}
