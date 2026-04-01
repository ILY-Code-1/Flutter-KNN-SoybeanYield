import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firestore_dataset_service.dart';
import '../../../../services/firestore_prediction_service.dart';
import '../../../admin/dataset_management/models/dataset_model.dart';
import '../../history/models/user_prediction_model.dart';

class PredictionController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _datasetService = FirestoreDatasetService();
  final _predictionService = FirestorePredictionService();

  final RxBool isLoading = false.obs;
  final RxString loadingMessage = ''.obs;

  // ── Form controllers (7 fields) ───────────────────────────────────────────
  final suhuController = TextEditingController();
  final curahHujanController = TextEditingController();
  final kelembabanController = TextEditingController();
  final phTanahController = TextEditingController();
  final nitrogenController = TextEditingController();
  final fosforController = TextEditingController();
  final kaliumController = TextEditingController();

  // ── KNN Algorithm ─────────────────────────────────────────────────────────

  static const int _k = 20;

  /// Runs K-Nearest Neighbors (K=20) with Min-Max normalization.
  /// Returns the predicted hasil_panen, the 20 nearest neighbors, and the
  /// normalized input values.
  Map<String, dynamic> runKNN({
    required List<DatasetModel> dataset,
    required double suhu,
    required double curahHujan,
    required double kelembaban,
    required double phTanah,
    required double nitrogen,
    required double fosfor,
    required double kalium,
  }) {
    // 1. Compute min & max for each feature from the full dataset
    double minSuhu = double.infinity, maxSuhu = double.negativeInfinity;
    double minCurahHujan = double.infinity,
        maxCurahHujan = double.negativeInfinity;
    double minKelembaban = double.infinity,
        maxKelembaban = double.negativeInfinity;
    double minPhTanah = double.infinity, maxPhTanah = double.negativeInfinity;
    double minNitrogen = double.infinity, maxNitrogen = double.negativeInfinity;
    double minFosfor = double.infinity, maxFosfor = double.negativeInfinity;
    double minKalium = double.infinity, maxKalium = double.negativeInfinity;

    for (final d in dataset) {
      if (d.suhu < minSuhu) minSuhu = d.suhu;
      if (d.suhu > maxSuhu) maxSuhu = d.suhu;
      if (d.curahHujan < minCurahHujan) minCurahHujan = d.curahHujan;
      if (d.curahHujan > maxCurahHujan) maxCurahHujan = d.curahHujan;
      if (d.kelembaban < minKelembaban) minKelembaban = d.kelembaban;
      if (d.kelembaban > maxKelembaban) maxKelembaban = d.kelembaban;
      if (d.phTanah < minPhTanah) minPhTanah = d.phTanah;
      if (d.phTanah > maxPhTanah) maxPhTanah = d.phTanah;
      if (d.nitrogen < minNitrogen) minNitrogen = d.nitrogen;
      if (d.nitrogen > maxNitrogen) maxNitrogen = d.nitrogen;
      if (d.fosfor < minFosfor) minFosfor = d.fosfor;
      if (d.fosfor > maxFosfor) maxFosfor = d.fosfor;
      if (d.kalium < minKalium) minKalium = d.kalium;
      if (d.kalium > maxKalium) maxKalium = d.kalium;
    }

    // 2. Normalize input using Min-Max: x_norm = (x - min) / (max - min)
    double norm(double x, double mn, double mx) =>
        (mx - mn) == 0 ? 0.0 : (x - mn) / (mx - mn);

    final normInput = {
      'suhu': norm(suhu, minSuhu, maxSuhu),
      'curah_hujan': norm(curahHujan, minCurahHujan, maxCurahHujan),
      'kelembaban': norm(kelembaban, minKelembaban, maxKelembaban),
      'ph_tanah': norm(phTanah, minPhTanah, maxPhTanah),
      'nitrogen': norm(nitrogen, minNitrogen, maxNitrogen),
      'fosfor': norm(fosfor, minFosfor, maxFosfor),
      'kalium': norm(kalium, minKalium, maxKalium),
    };

    // 3. Compute Euclidean distance to each dataset point (normalized)
    final distances = dataset.map((d) {
      final nSuhu = norm(d.suhu, minSuhu, maxSuhu);
      final nCurahHujan = norm(d.curahHujan, minCurahHujan, maxCurahHujan);
      final nKelembaban = norm(d.kelembaban, minKelembaban, maxKelembaban);
      final nPhTanah = norm(d.phTanah, minPhTanah, maxPhTanah);
      final nNitrogen = norm(d.nitrogen, minNitrogen, maxNitrogen);
      final nFosfor = norm(d.fosfor, minFosfor, maxFosfor);
      final nKalium = norm(d.kalium, minKalium, maxKalium);

      final dist = sqrt(
        pow(normInput['suhu']! - nSuhu, 2) +
            pow(normInput['curah_hujan']! - nCurahHujan, 2) +
            pow(normInput['kelembaban']! - nKelembaban, 2) +
            pow(normInput['ph_tanah']! - nPhTanah, 2) +
            pow(normInput['nitrogen']! - nNitrogen, 2) +
            pow(normInput['fosfor']! - nFosfor, 2) +
            pow(normInput['kalium']! - nKalium, 2),
      );

      return {'distance': dist, 'hasilPanen': d.hasilPanen};
    }).toList();

    // 4. Sort by distance ascending
    distances.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

    // 5. Take K nearest neighbors
    final kNeighbors = distances.take(_k).toList();

    // 6. Average hasil_panen of K neighbors
    final avgHasilPanen =
        kNeighbors.map((n) => n['hasilPanen'] as double).reduce((a, b) => a + b) /
            kNeighbors.length;

    return {
      'result': avgHasilPanen,
      'normalized_input': normInput,
      'neighbors': kNeighbors
          .map((n) => {
                'distance': n['distance'],
                'hasil_panen': n['hasilPanen'],
              })
          .toList(),
    };
  }

  // ── Validation & Predict ─────────────────────────────────────────────────

  Future<void> validateAndPredict() async {
    final suhu = double.tryParse(suhuController.text.trim());
    final curahHujan = double.tryParse(curahHujanController.text.trim());
    final kelembaban = double.tryParse(kelembabanController.text.trim());
    final phTanah = double.tryParse(phTanahController.text.trim());
    final nitrogen = double.tryParse(nitrogenController.text.trim());
    final fosfor = double.tryParse(fosforController.text.trim());
    final kalium = double.tryParse(kaliumController.text.trim());

    if (suhu == null ||
        curahHujan == null ||
        kelembaban == null ||
        phTanah == null ||
        nitrogen == null ||
        fosfor == null ||
        kalium == null) {
      Get.snackbar(
        'Data Tidak Lengkap',
        'Semua field harus diisi dengan angka yang valid',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    loadingMessage.value = 'Mengambil dataset...';

    try {
      // Step 1: Fetch dataset from Firestore
      final dataset = await _datasetService.getAll();

      if (dataset.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Dataset Kosong',
          'Tidak ada data training. Hubungi admin.',
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      loadingMessage.value = 'Menghitung prediksi KNN...';

      // Step 2–6: Run KNN
      final knnResult = runKNN(
        dataset: dataset,
        suhu: suhu,
        curahHujan: curahHujan,
        kelembaban: kelembaban,
        phTanah: phTanah,
        nitrogen: nitrogen,
        fosfor: fosfor,
        kalium: kalium,
      );

      final predictedYield =
          double.parse((knnResult['result'] as double).toStringAsFixed(3));
      final normalizedInput =
          knnResult['normalized_input'] as Map<String, double>;
      final neighbors =
          knnResult['neighbors'] as List<Map<String, dynamic>>;

      loadingMessage.value = 'Menyimpan hasil prediksi...';

      // Step 7: Save to Firestore
      final model = UserPredictionModel(
        id: '',
        userId: _auth.currentUserId.value,
        username: _auth.currentUsername.value,
        date: DateTime.now(),
        result: predictedYield,
        suhu: suhu,
        curahHujan: curahHujan,
        kelembaban: kelembaban,
        phTanah: phTanah,
        nitrogen: nitrogen,
        fosfor: fosfor,
        kalium: kalium,
      );

      final docId = await _predictionService.save(
        model,
        neighbors: neighbors,
        normalizedInput: normalizedInput,
        knnK: _k,
      );

      isLoading.value = false;

      if (docId != null) {
        Get.snackbar(
          'Berhasil',
          'Prediksi berhasil dihitung dan disimpan',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );

        final savedModel = UserPredictionModel(
          id: docId,
          userId: model.userId,
          username: model.username,
          date: model.date,
          result: predictedYield,
          suhu: suhu,
          curahHujan: curahHujan,
          kelembaban: kelembaban,
          phTanah: phTanah,
          nitrogen: nitrogen,
          fosfor: fosfor,
          kalium: kalium,
        );

        clearForm();
        Get.offNamedUntil(
          AppRoutes.userPredictionDetail,
          (route) => route.settings.name == AppRoutes.userDashboard,
          arguments: savedModel,
        );
      } else {
        Get.snackbar(
          'Gagal Menyimpan',
          'Prediksi berhasil dihitung namun gagal disimpan. Coba lagi.',
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        Get.back();
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal menjalankan prediksi: $e',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void clearForm() {
    suhuController.clear();
    curahHujanController.clear();
    kelembabanController.clear();
    phTanahController.clear();
    nitrogenController.clear();
    fosforController.clear();
    kaliumController.clear();
  }

  @override
  void onClose() {
    suhuController.dispose();
    curahHujanController.dispose();
    kelembabanController.dispose();
    phTanahController.dispose();
    nitrogenController.dispose();
    fosforController.dispose();
    kaliumController.dispose();
    super.onClose();
  }
}
