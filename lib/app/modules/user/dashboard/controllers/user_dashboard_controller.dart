import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firestore_prediction_service.dart';
import '../../history/models/user_prediction_model.dart';

class UserDashboardController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _predictionService = FirestorePredictionService();

  // ── Double back to exit ────────────────────────────────────────────────────
  DateTime? _lastBackPress;

  bool handleBackPress() {
    final now = DateTime.now();
    const threshold = Duration(seconds: 2);
    if (_lastBackPress == null || now.difference(_lastBackPress!) > threshold) {
      _lastBackPress = now;
      Get.snackbar(
        'Keluar Aplikasi',
        'Tekan sekali lagi untuk keluar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: threshold,
      );
      return false;
    }
    return true;
  }

  final RxInt totalPrediksi = 0.obs;
  final RxString lastPredictionDate = ''.obs;
  final Rxn<UserPredictionModel> lastPrediction = Rxn<UserPredictionModel>();
  final RxBool isLoadingStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  Future<void> _loadStats() async {
    isLoadingStats.value = true;
    try {
      final userId = _auth.currentUserId.value;
      final results = await Future.wait([
        _predictionService.countUserPredictions(userId),
        _predictionService.getLatestUserPrediction(userId),
      ]);

      totalPrediksi.value = results[0] as int;

      final latest = results[1] as UserPredictionModel?;
      lastPrediction.value = latest;

      if (latest != null) {
        lastPredictionDate.value =
            DateFormat('dd MMM yyyy, HH:mm').format(latest.date);
      } else {
        lastPredictionDate.value = '-';
      }
    } catch (_) {
      lastPredictionDate.value = '-';
    } finally {
      isLoadingStats.value = false;
    }
  }

  void refreshStats() => _loadStats();

  void goToLastPredictionDetail() {
    final pred = lastPrediction.value;
    if (pred != null) {
      Get.toNamed(AppRoutes.userPredictionDetail, arguments: pred);
    }
  }

  void confirmLogout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () => _auth.logoutWithLoading(),
    );
  }
}
