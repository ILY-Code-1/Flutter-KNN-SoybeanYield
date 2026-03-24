import '../../modules/admin/dataset_management/models/dataset_model.dart';

class DatasetDummy {
  static List<DatasetModel> getDatasets() => const [
        DatasetModel(
          id: '1',
          suhu: 29,
          curahHujan: 900,
          kelembaban: 75,
          phTanah: 6.4,
          nitrogen: 35,
          fosfor: 20,
          kalium: 150,
          hasilPanen: 2.94,
        ),
        DatasetModel(
          id: '2',
          suhu: 27,
          curahHujan: 850,
          kelembaban: 70,
          phTanah: 6.1,
          nitrogen: 30,
          fosfor: 18,
          kalium: 140,
          hasilPanen: 2.50,
        ),
        DatasetModel(
          id: '3',
          suhu: 31,
          curahHujan: 950,
          kelembaban: 80,
          phTanah: 6.8,
          nitrogen: 40,
          fosfor: 25,
          kalium: 160,
          hasilPanen: 3.20,
        ),
      ];
}
