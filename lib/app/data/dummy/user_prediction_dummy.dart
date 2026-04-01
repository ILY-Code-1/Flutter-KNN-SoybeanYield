import '../../modules/user/history/models/user_prediction_model.dart';

class UserPredictionDummy {
  static List<UserPredictionModel> getHistory() => [
        UserPredictionModel(
          id: '1',
          userId: 'dummy_user',
          username: 'Petani',
          date: DateTime(2026, 3, 12),
          result: 3.1,
          suhu: 29,
          curahHujan: 900,
          kelembaban: 75,
          phTanah: 6.4,
          nitrogen: 35,
          fosfor: 20,
          kalium: 150,
        ),
        UserPredictionModel(
          id: '2',
          userId: 'dummy_user',
          username: 'Petani',
          date: DateTime(2026, 4, 12),
          result: 5.0,
          suhu: 28,
          curahHujan: 850,
          kelembaban: 70,
          phTanah: 6.2,
          nitrogen: 38,
          fosfor: 22,
          kalium: 145,
        ),
      ];
}
