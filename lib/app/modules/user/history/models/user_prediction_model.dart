import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a completed prediction — includes both the input features
/// and the KNN-computed [result], plus Firestore-backed fields.
class UserPredictionModel {
  final String id; // Firestore document ID
  final String userId;
  final String username;
  final DateTime date;
  final double result; // KNN output (ton/ha)
  final double? actualYield; // filled by user later

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
    required this.userId,
    required this.username,
    required this.date,
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

  factory UserPredictionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserPredictionModel(
      id: doc.id,
      userId: data['user_id'] as String? ?? '',
      username: data['username'] as String? ?? '',
      date: (data['timestamp'] as Timestamp).toDate(),
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

  Map<String, dynamic> toFirestore({
    List<Map<String, dynamic>>? neighbors,
    Map<String, double>? normalizedInput,
    int knnK = 20,
  }) =>
      {
        'user_id': userId,
        'username': username,
        'timestamp': Timestamp.fromDate(date),
        'result': result,
        'suhu': suhu,
        'curah_hujan': curahHujan,
        'kelembaban': kelembaban,
        'ph_tanah': phTanah,
        'nitrogen': nitrogen,
        'fosfor': fosfor,
        'kalium': kalium,
        'actual_yield': actualYield,
        'knn_k': knnK,
        'knn_summary': {
          'normalized_input': normalizedInput ?? {},
          'neighbors': neighbors ?? [],
        },
      };

  UserPredictionModel copyWith({double? actualYield}) {
    return UserPredictionModel(
      id: id,
      userId: userId,
      username: username,
      date: date,
      result: result,
      suhu: suhu,
      curahHujan: curahHujan,
      kelembaban: kelembaban,
      phTanah: phTanah,
      nitrogen: nitrogen,
      fosfor: fosfor,
      kalium: kalium,
      actualYield: actualYield ?? this.actualYield,
    );
  }
}
