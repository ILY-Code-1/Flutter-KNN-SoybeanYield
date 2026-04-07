import 'package:cloud_firestore/cloud_firestore.dart';

import '../modules/admin/dataset_management/models/dataset_model.dart';

class FirestoreDatasetService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'dataset_soybean';

  // ── Init ──────────────────────────────────────────────────────────────────

  /// Returns true if the collection has no documents yet.
  Future<bool> isEmpty() async {
    try {
      final snap =
          await _db.collection(_collection).limit(1).get();
      return snap.docs.isEmpty;
    } catch (_) {
      return true;
    }
  }

  /// Parses CSV content (with header row) and bulk-uploads to Firestore.
  /// Uses a fresh WriteBatch for each chunk of 499 rows (Firestore limit = 500).
  /// Returns count of added rows.
  Future<int> initializeFromCsv(String csvContent) async {
    final lines = csvContent
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) return 0;

    // First line is header — skip it
    final dataLines = lines.sublist(1);
    int added = 0;

    // A committed WriteBatch cannot be reused — always create a new one.
    WriteBatch batch = _db.batch();
    int batchCount = 0;

    for (final line in dataLines) {
      final parts = line.split(',');
      if (parts.length < 8) continue;

      final suhu = double.tryParse(parts[0].trim());
      final curahHujan = double.tryParse(parts[1].trim());
      final kelembaban = double.tryParse(parts[2].trim());
      final phTanah = double.tryParse(parts[3].trim());
      final nitrogen = double.tryParse(parts[4].trim());
      final fosfor = double.tryParse(parts[5].trim());
      final kalium = double.tryParse(parts[6].trim());
      final hasilPanen = double.tryParse(parts[7].trim());

      if (suhu == null ||
          curahHujan == null ||
          kelembaban == null ||
          phTanah == null ||
          nitrogen == null ||
          fosfor == null ||
          kalium == null ||
          hasilPanen == null) {
        continue;
      }

      final docRef = _db.collection(_collection).doc();
      batch.set(docRef, {
        'suhu': suhu,
        'curah_hujan': curahHujan,
        'kelembaban': kelembaban,
        'ph_tanah': phTanah,
        'nitrogen': nitrogen,
        'fosfor': fosfor,
        'kalium': kalium,
        'hasil_panen': hasilPanen,
      });
      batchCount++;
      added++;

      // Firestore limit is 500 writes per batch.
      // Commit and create a fresh batch before hitting the limit.
      if (batchCount >= 499) {
        await batch.commit();
        batch = _db.batch(); // ← new batch object required after commit
        batchCount = 0;
      }
    }

    // Commit any remaining writes
    if (batchCount > 0) {
      await batch.commit();
    }

    return added;
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<DatasetModel>> getAll() async {
    try {
      final snap = await _db.collection(_collection).get();
      return snap.docs.map(DatasetModel.fromFirestore).toList();
    } catch (_) {
      return [];
    }
  }

  Stream<List<DatasetModel>> streamAll() {
    return _db.collection(_collection).snapshots().map(
          (snap) => snap.docs.map(DatasetModel.fromFirestore).toList(),
        );
  }

  Future<int> count() async {
    try {
      final snap = await _db.collection(_collection).count().get();
      return snap.count ?? 0;
    } catch (_) {
      return 0;
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<String?> add(DatasetModel model) async {
    try {
      final docRef = _db.collection(_collection).doc();
      await docRef.set(model.toFirestore());
      return docRef.id;
    } catch (_) {
      return null;
    }
  }

  /// Checks for exact duplicate (all 8 field values match).
  Future<bool> isDuplicate(Map<String, dynamic> data) async {
    try {
      final snap = await _db
          .collection(_collection)
          .where('suhu', isEqualTo: data['suhu'])
          .where('curah_hujan', isEqualTo: data['curah_hujan'])
          .where('kelembaban', isEqualTo: data['kelembaban'])
          .where('ph_tanah', isEqualTo: data['ph_tanah'])
          .where('nitrogen', isEqualTo: data['nitrogen'])
          .where('fosfor', isEqualTo: data['fosfor'])
          .where('kalium', isEqualTo: data['kalium'])
          .where('hasil_panen', isEqualTo: data['hasil_panen'])
          .limit(1)
          .get();
      return snap.docs.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Checks for a document matching all 7 input features (excluding hasil_panen).
  Future<String?> findDocumentByInputs(Map<String, dynamic> inputs) async {
    try {
      final snap = await _db
          .collection(_collection)
          .where('suhu', isEqualTo: inputs['suhu'])
          .where('curah_hujan', isEqualTo: inputs['curah_hujan'])
          .where('kelembaban', isEqualTo: inputs['kelembaban'])
          .where('ph_tanah', isEqualTo: inputs['ph_tanah'])
          .where('nitrogen', isEqualTo: inputs['nitrogen'])
          .where('fosfor', isEqualTo: inputs['fosfor'])
          .where('kalium', isEqualTo: inputs['kalium'])
          .limit(1)
          .get();
      return snap.docs.isNotEmpty ? snap.docs.first.id : null;
    } catch (_) {
      return null;
    }
  }

  /// Upload multiple CSV lines, checking each for duplicates.
  /// Returns {added, skipped, failed} counts.
  Future<Map<String, int>> uploadLines(List<String> lines) async {
    int added = 0, skipped = 0, failed = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final parts = line.split(',');
      if (parts.length < 8) {
        failed++;
        continue;
      }

      final suhu = double.tryParse(parts[0].trim());
      final curahHujan = double.tryParse(parts[1].trim());
      final kelembaban = double.tryParse(parts[2].trim());
      final phTanah = double.tryParse(parts[3].trim());
      final nitrogen = double.tryParse(parts[4].trim());
      final fosfor = double.tryParse(parts[5].trim());
      final kalium = double.tryParse(parts[6].trim());
      final hasilPanen = double.tryParse(parts[7].trim());

      if (suhu == null ||
          curahHujan == null ||
          kelembaban == null ||
          phTanah == null ||
          nitrogen == null ||
          fosfor == null ||
          kalium == null ||
          hasilPanen == null) {
        failed++;
        continue;
      }

      final data = {
        'suhu': suhu,
        'curah_hujan': curahHujan,
        'kelembaban': kelembaban,
        'ph_tanah': phTanah,
        'nitrogen': nitrogen,
        'fosfor': fosfor,
        'kalium': kalium,
        'hasil_panen': hasilPanen,
      };

      try {
        final dup = await isDuplicate(data);
        if (dup) {
          skipped++;
        } else {
          await _db.collection(_collection).add(data);
          added++;
        }
      } catch (_) {
        failed++;
      }
    }

    return {'added': added, 'skipped': skipped, 'failed': failed};
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> updateHasilPanen(String docId, double hasilPanen) async {
    try {
      await _db
          .collection(_collection)
          .doc(docId)
          .update({'hasil_panen': hasilPanen});
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addOrUpdateByInputs({
    required double suhu,
    required double curahHujan,
    required double kelembaban,
    required double phTanah,
    required double nitrogen,
    required double fosfor,
    required double kalium,
    required double hasilPanen,
  }) async {
    final inputs = {
      'suhu': suhu,
      'curah_hujan': curahHujan,
      'kelembaban': kelembaban,
      'ph_tanah': phTanah,
      'nitrogen': nitrogen,
      'fosfor': fosfor,
      'kalium': kalium,
    };

    try {
      final existingId = await findDocumentByInputs(inputs);
      if (existingId != null) {
        return updateHasilPanen(existingId, hasilPanen);
      } else {
        await _db.collection(_collection).add({
          ...inputs,
          'hasil_panen': hasilPanen,
        });
        return true;
      }
    } catch (_) {
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> delete(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
