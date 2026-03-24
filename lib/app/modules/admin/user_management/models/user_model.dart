import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String role;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  // ── Firestore serialisation ───────────────────────────────────────────────

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      createdAt:
          (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'username': username,
        'email': email,
        'role': role,
        'created_at': Timestamp.fromDate(createdAt),
      };

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Display-friendly role: 'admin' → 'Admin', 'user' → 'User'.
  String get roleDisplay =>
      role.isEmpty ? role : role[0].toUpperCase() + role.substring(1);

  bool get isAdmin => role.toLowerCase() == 'admin';

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
