import '../../modules/admin/user_management/models/user_model.dart';

class UserDummy {
  static List<UserModel> getUsers() => [
        UserModel(
          id: '1',
          username: 'Alif',
          role: 'Admin',
          createdAt: DateTime(2026, 4, 12),
        ),
        UserModel(
          id: '2',
          username: 'Dimas',
          role: 'User',
          createdAt: DateTime(2026, 3, 5),
        ),
        UserModel(
          id: '3',
          username: 'Aldi',
          role: 'User',
          createdAt: DateTime(2026, 2, 20),
        ),
      ];
}
