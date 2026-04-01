import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../services/firestore_dataset_service.dart';
import '../../../../services/firestore_prediction_service.dart';
import '../models/dashboard_stat_model.dart';

class DashboardController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _datasetService = FirestoreDatasetService();
  final _predictionService = FirestorePredictionService();
  final _db = FirebaseFirestore.instance;

  final RxInt totalDataset = 0.obs;
  final RxInt totalPrediksi = 0.obs;
  final RxInt totalPetani = 0.obs;
  final RxBool isLoadingStats = false.obs;

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

  List<DashboardStatModel> get stats => [
        DashboardStatModel(
          label: 'Jumlah Dataset',
          value: totalDataset.value.toString(),
          icon: Icons.storage_outlined,
          backgroundColor: AppColors.accentTeal,
          valueColor: AppColors.white,
          labelColor: AppColors.white,
        ),
        DashboardStatModel(
          label: 'Jumlah Prediksi',
          value: totalPrediksi.value.toString(),
          icon: Icons.analytics_outlined,
          backgroundColor: const Color(0xFFE8F5E9),
          valueColor: AppColors.orange,
          labelColor: AppColors.textSecondary,
        ),
        DashboardStatModel(
          label: 'Jumlah Petani',
          value: totalPetani.value.toString(),
          icon: Iconsax.people,
          backgroundColor: AppColors.accentTeal,
          valueColor: AppColors.white,
          labelColor: AppColors.white,
        ),
      ];

  @override
  void onInit() {
    super.onInit();
    _loadStats();
  }

  Future<void> _loadStats() async {
    isLoadingStats.value = true;
    try {
      final results = await Future.wait([
        _datasetService.count(),
        _predictionService.countAll(),
        _countPetani(),
      ]);
      totalDataset.value = results[0];
      totalPrediksi.value = results[1];
      totalPetani.value = results[2];
    } catch (_) {
      // silently fail — keep zeros
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<int> _countPetani() async {
    try {
      final snap = await _db
          .collection('users_soybean')
          .where('role', isEqualTo: 'user')
          .count()
          .get();
      return snap.count ?? 0;
    } catch (_) {
      return 0;
    }
  }

  void refreshStats() => _loadStats();

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () => _auth.logoutWithLoading(),
    );
  }
}
