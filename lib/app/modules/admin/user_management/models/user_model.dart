import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String password;
  final String role;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
    required this.password,
  });

  // ── Firestore serialisation ───────────────────────────────────────────────

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      username: data['username'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      password: data['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'username': username,
        'role': role,
        'created_at': Timestamp.fromDate(createdAt),
      };

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get roleDisplay =>
      role.isEmpty ? role : role[0].toUpperCase() + role.substring(1);

  bool get isAdmin => role.toLowerCase() == 'admin';

  UserModel copyWith({
    String? id,
    String? username,
    String? role,
    DateTime? createdAt,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }
}
