import 'package:cloud_firestore/cloud_firestore.dart';

import '../modules/admin/prediction_history/models/prediction_model.dart';
import '../modules/user/history/models/user_prediction_model.dart';

class FirestorePredictionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'soybean_prediction';

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<String?> save(
    UserPredictionModel model, {
    List<Map<String, dynamic>>? neighbors,
    Map<String, double>? normalizedInput,
    int knnK = 20,
  }) async {
    try {
      final docRef = _db.collection(_collection).doc();
      await docRef.set(model.toFirestore(
        neighbors: neighbors,
        normalizedInput: normalizedInput,
        knnK: knnK,
      ));
      return docRef.id;
    } catch (_) {
      return null;
    }
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  /// All predictions for a specific user, ordered newest first.
  Future<List<UserPredictionModel>> getUserPredictions(String userId) async {
    try {
      final snap = await _db
          .collection(_collection)
          .where('user_id', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return snap.docs.map(UserPredictionModel.fromFirestore).toList();
    } catch (_) {
      return [];
    }
  }

  Stream<List<UserPredictionModel>> streamUserPredictions(String userId) {
    return _db
        .collection(_collection)
        .where('user_id', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map(UserPredictionModel.fromFirestore).toList());
  }

  /// Latest single prediction for a user (for dashboard widget).
  Future<UserPredictionModel?> getLatestUserPrediction(String userId) async {
    try {
      final snap = await _db
          .collection(_collection)
          .where('user_id', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      return UserPredictionModel.fromFirestore(snap.docs.first);
    } catch (_) {
      return null;
    }
  }

  /// All predictions across all users (admin view), ordered newest first.
  Future<List<PredictionModel>> getAllPredictions() async {
    try {
      final snap = await _db
          .collection(_collection)
          .orderBy('timestamp', descending: true)
          .get();
      return snap.docs.map(PredictionModel.fromFirestore).toList();
    } catch (_) {
      return [];
    }
  }

  Stream<List<PredictionModel>> streamAllPredictions() {
    return _db
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(PredictionModel.fromFirestore).toList());
  }

  // ── Count ─────────────────────────────────────────────────────────────────

  Future<int> countAll() async {
    try {
      final snap = await _db.collection(_collection).count().get();
      return snap.count ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<int> countUserPredictions(String userId) async {
    try {
      final snap = await _db
          .collection(_collection)
          .where('user_id', isEqualTo: userId)
          .count()
          .get();
      return snap.count ?? 0;
    } catch (_) {
      return 0;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> updateActualYield(String docId, double actualYield) async {
    try {
      await _db
          .collection(_collection)
          .doc(docId)
          .update({'actual_yield': actualYield});
      return true;
    } catch (_) {
      return false;
    }
  }
}
