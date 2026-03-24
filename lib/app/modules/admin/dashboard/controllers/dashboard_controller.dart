import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/dashboard_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../models/dashboard_stat_model.dart';

class DashboardController extends GetxController {
  final _auth = Get.find<AuthController>();

  late final List<DashboardStatModel> stats;

  @override
  void onInit() {
    super.onInit();
    stats = [
      DashboardStatModel(
        label: 'Jumlah Dataset',
        value: DashboardDummy.totalDataset.toString(),
        icon: Icons.storage_outlined,
        backgroundColor: AppColors.accentTeal,
        valueColor: AppColors.white,
        labelColor: AppColors.white,
      ),
      DashboardStatModel(
        label: 'Jumlah Prediksi',
        value: DashboardDummy.totalPrediksi.toString(),
        icon: Icons.analytics_outlined,
        backgroundColor: const Color(0xFFE8F5E9),
        valueColor: AppColors.orange,
        labelColor: AppColors.textSecondary,
      ),
      DashboardStatModel(
        label: 'Jumlah Petani',
        value: DashboardDummy.totalPetani.toString(),
        icon: Iconsax.people,
        backgroundColor: AppColors.accentTeal,
        valueColor: AppColors.white,
        labelColor: AppColors.white,
      ),
    ];
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
