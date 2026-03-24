import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/prediction_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../models/prediction_model.dart';

class PredictionHistoryController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxList<PredictionModel> predictions = <PredictionModel>[].obs;
  final RxList<PredictionModel> filteredPredictions = <PredictionModel>[].obs;
  final RxString selectedFilter = 'Semua'.obs;
  final Rxn<PredictionModel> selectedPrediction = Rxn<PredictionModel>();

  static const Map<String, int> _monthMap = {
    'Januari': 1,
    'Februari': 2,
    'Maret': 3,
    'April': 4,
    'Mei': 5,
    'Juni': 6,
    'Juli': 7,
    'Agustus': 8,
    'September': 9,
    'Oktober': 10,
    'November': 11,
    'Desember': 12,
  };

  @override
  void onInit() {
    super.onInit();
    predictions.assignAll(PredictionDummy.getPredictions());
    filteredPredictions.assignAll(predictions);
  }

  void filterByMonth(String option) {
    selectedFilter.value = option;
    if (option == 'Semua') {
      filteredPredictions.assignAll(predictions);
      return;
    }
    final parts = option.split(' ');
    if (parts.length < 2) return;
    final monthNum = _monthMap[parts[0]];
    final year = int.tryParse(parts[1]);
    if (monthNum == null || year == null) return;
    filteredPredictions.assignAll(
      predictions.where(
        (p) => p.date.month == monthNum && p.date.year == year,
      ),
    );
  }

  void showFilterSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Filter Waktu Prediksi',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...PredictionDummy.filterOptions.map(
              (option) => Obx(
                () => ListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    option,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: selectedFilter.value == option
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selectedFilter.value == option
                          ? AppColors.primaryGreen
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: selectedFilter.value == option
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryGreen,
                          size: 20,
                        )
                      : const Icon(
                          Icons.circle_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                  onTap: () {
                    filterByMonth(option);
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void selectPrediction(PredictionModel prediction) {
    selectedPrediction.value = prediction;
    Get.toNamed(AppRoutes.adminPredictionDetail);
  }

  void downloadResult() {
    Get.snackbar(
      'Info',
      'Fitur unduh belum tersedia',
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () {
        _auth.logout();
        Get.offAllNamed(AppRoutes.signIn);
      },
    );
  }
}
