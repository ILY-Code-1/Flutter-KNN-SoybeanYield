import 'package:cloud_firestore/cloud_firestore.dart';

import '../modules/admin/user_management/models/user_model.dart';

/// Manages CRUD operations for the `users-soybean` Firestore collection.
class FirestoreUserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collection = 'users-soybean';

  // ── Read ──────────────────────────────────────────────────────────────────

  /// Returns all user documents ordered by creation date (newest first).
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

  /// Returns a single user by [uid], or null if not found.
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  /// Returns only the role string for [uid], or null on failure.
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _db.collection(_collection).doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data();
      return data?['role'] as String?;
    } catch (_) {
      return null;
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  /// Creates the Firestore document for a newly registered user.
  /// The document ID is the Firebase Auth [uid].
  Future<bool> createUserDoc(
    String uid,
    String username,
    String role,
  ) async {
    try {
      final email = '${username.toLowerCase()}@soybeanyield.com';
      final user = UserModel(
        id: uid,
        username: username,
        email: email,
        role: role,
        createdAt: DateTime.now(),
      );
      await _db.collection(_collection).doc(uid).set(user.toFirestore());
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  /// Updates [username] and [role] for the document identified by [uid].
  ///
  /// NOTE: The corresponding Firebase Auth email is NOT updated here because
  /// changing another account's email requires the Firebase Admin SDK
  /// (server-side). The internal email field in Firestore is updated to stay
  /// consistent, but the Auth credentials remain tied to the original email.
  Future<bool> updateUser(
    String uid,
    String newUsername,
    String role,
  ) async {
    try {
      await _db.collection(_collection).doc(uid).update({
        'username': newUsername,
        'email': '${newUsername.toLowerCase()}@soybeanyield.com',
        'role': role,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  /// Deletes the Firestore document for [uid].
  ///
  /// NOTE: The Firebase Auth account is NOT deleted (requires Admin SDK).
  /// The orphaned Auth account can be removed via the Firebase Console or a
  /// Cloud Function trigger.
  Future<bool> deleteUserDoc(String uid) async {
    try {
      await _db.collection(_collection).doc(uid).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
