import 'package:cloud_firestore/cloud_firestore.dart';

import '../modules/admin/user_management/models/user_model.dart';

class FirestoreUserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'users-soybean';

  // ── Auth ──────────────────────────────────────────────────────────────────

  /// Cek username + password langsung ke Firestore (plain text).
  /// Return [UserModel] jika cocok, null jika salah.
  Future<UserModel?> login(String username, String password) async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      final stored = data['password'] as String? ?? '';

      if (stored != password) return null;

      return UserModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .orderBy('created_at', descending: true)
          .get();
      return snapshot.docs.map(UserModel.fromFirestore).toList();
    } catch (_) {
      return [];
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  /// Cek apakah username sudah dipakai user lain.
  Future<bool> isUsernameExists(String username, {String? excludeUid}) async {
    try {
      final snapshot = await _db
          .collection(_collection)
          .where('username', isEqualTo: username)
          .limit(2)
          .get();

      if (snapshot.docs.isEmpty) return false;
      if (excludeUid == null) return true;
      return snapshot.docs.any((d) => d.id != excludeUid);
    } catch (_) {
      return false;
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  /// Buat user baru di Firestore. Password disimpan plain text.
  Future<String?> createUser(
    String username,
    String password,
    String role,
  ) async {
    try {
      final docRef = _db.collection(_collection).doc();
      final user = UserModel(
        id: docRef.id,
        username: username,
        role: role,
        createdAt: DateTime.now(),
        password: password,
      );
      await docRef.set({
        ...user.toFirestore(),
        'password': password,
      });
      return docRef.id;
    } catch (_) {
      return null;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> updateUser(
    String uid,
    String newUsername,
    String role,
  ) async {
    try {
      await _db.collection(_collection).doc(uid).update({
        'username': newUsername,
        'role': role,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> deleteUserDoc(String uid) async {
    try {
      await _db.collection(_collection).doc(uid).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
