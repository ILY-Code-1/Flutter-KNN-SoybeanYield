import '../../modules/admin/prediction_history/models/prediction_model.dart';

class PredictionDummy {
  static List<PredictionModel> getPredictions() => [
        PredictionModel(
          id: '1',
          date: DateTime(2026, 3, 12),
          username: 'Alif',
          result: 3.1,
          suhu: 29,
          curahHujan: 900,
          kelembaban: 75,
          phTanah: 6.4,
          nitrogen: 35,
          fosfor: 20,
          kalium: 150,
        ),
        PredictionModel(
          id: '2',
          date: DateTime(2026, 4, 12),
          username: 'Alif',
          result: 5.0,
          suhu: 28,
          curahHujan: 850,
          kelembaban: 70,
          phTanah: 6.2,
          nitrogen: 38,
          fosfor: 22,
          kalium: 145,
        ),
        PredictionModel(
          id: '3',
          date: DateTime(2026, 3, 5),
          username: 'Dimas',
          result: 2.94,
          suhu: 30,
          curahHujan: 920,
          kelembaban: 80,
          phTanah: 6.5,
          nitrogen: 33,
          fosfor: 18,
          kalium: 160,
        ),
        PredictionModel(
          id: '4',
          date: DateTime(2026, 2, 20),
          username: 'Aldi',
          result: 4.2,
          suhu: 27,
          curahHujan: 870,
          kelembaban: 72,
          phTanah: 6.8,
          nitrogen: 40,
          fosfor: 25,
          kalium: 140,
        ),
      ];

  /// All available filter options derived from dummy data
  static const List<String> filterOptions = [
    'Semua',
    'Februari 2026',
    'Maret 2026',
    'April 2026',
  ];
}
