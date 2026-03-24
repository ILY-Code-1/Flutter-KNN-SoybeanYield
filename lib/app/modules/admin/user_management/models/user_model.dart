class UserModel {
  final String id;
  final String username;
  final String role;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
