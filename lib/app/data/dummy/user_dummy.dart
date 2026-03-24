import '../../modules/admin/user_management/models/user_model.dart';

class UserDummy {
  static List<UserModel> getUsers() => [
        UserModel(
          id: '1',
          username: 'Alif',
          email: 'alif@soybeanyield.com',
          role: 'admin',
          createdAt: DateTime(2026, 4, 12),
        ),
        UserModel(
          id: '2',
          username: 'Dimas',
          email: 'dimas@soybeanyield.com',
          role: 'user',
          createdAt: DateTime(2026, 3, 5),
        ),
        UserModel(
          id: '3',
          username: 'Aldi',
          email: 'aldi@soybeanyield.com',
          role: 'user',
          createdAt: DateTime(2026, 2, 20),
        ),
      ];
}
