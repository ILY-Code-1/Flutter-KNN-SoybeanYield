import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../history/models/user_prediction_model.dart';

class PredictionController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<UserPredictionModel> result = Rxn<UserPredictionModel>();

  // ── Form controllers (8 fields) ───────────────────────────────────────────
  final suhuController = TextEditingController();
  final curahHujanController = TextEditingController();
  final kelembabanController = TextEditingController();
  final phTanahController = TextEditingController();
  final nitrogenController = TextEditingController();
  final fosforController = TextEditingController();
  final kaliumController = TextEditingController();
  final hasilPanenController = TextEditingController(); // reference / label field

  // ── KNN Simulation ────────────────────────────────────────────────────────

  /// Dummy KNN approximation — replace with a real K-NN implementation later.
  /// Parameters match the training feature set; [hasilPanen] is a reference
  /// label and is not consumed by this simplified formula.
  double simulateKNN({
    required double suhu,
    required double curahHujan,
    required double kelembaban,
    required double phTanah,
    required double nitrogen,
    required double fosfor,
    required double kalium,
    required double hasilPanen,
  }) {
    return ((suhu * 0.1) +
            (curahHujan * 0.003) +
            (phTanah * 0.3) +
            (nitrogen * 0.05))
        .clamp(1.0, 6.0);
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
    final hasilPanen = double.tryParse(hasilPanenController.text.trim());

    if (suhu == null ||
        curahHujan == null ||
        kelembaban == null ||
        phTanah == null ||
        nitrogen == null ||
        fosfor == null ||
        kalium == null ||
        hasilPanen == null) {
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

    // Simulate network / processing delay
    await Future.delayed(const Duration(seconds: 1));

    final knnResult = simulateKNN(
      suhu: suhu,
      curahHujan: curahHujan,
      kelembaban: kelembaban,
      phTanah: phTanah,
      nitrogen: nitrogen,
      fosfor: fosfor,
      kalium: kalium,
      hasilPanen: hasilPanen,
    );

    result.value = UserPredictionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      result: double.parse(knnResult.toStringAsFixed(2)),
      suhu: suhu,
      curahHujan: curahHujan,
      kelembaban: kelembaban,
      phTanah: phTanah,
      nitrogen: nitrogen,
      fosfor: fosfor,
      kalium: kalium,
    );

    isLoading.value = false;

    Get.toNamed(
      AppRoutes.userPredictionDetail,
      arguments: result.value,
    );
  }

  void clearForm() {
    suhuController.clear();
    curahHujanController.clear();
    kelembabanController.clear();
    phTanahController.clear();
    nitrogenController.clear();
    fosforController.clear();
    kaliumController.clear();
    hasilPanenController.clear();
    result.value = null;
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
    hasilPanenController.dispose();
    super.onClose();
  }
}
