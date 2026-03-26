import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/dashboard_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../models/dashboard_stat_model.dart';

class DashboardController extends GetxController {
  final _auth = Get.find<AuthController>();

  late final List<DashboardStatModel> stats;

  // ── Double back to exit ────────────────────────────────────────────────────
  // Simpan waktu terakhir tombol back ditekan untuk deteksi double-tap.
  DateTime? _lastBackPress;

  /// Dipanggil dari PopScope di DashboardView.
  /// Return true  → izinkan app keluar (back kedua dalam 2 detik).
  /// Return false → tampilkan snackbar, tahan back.
  /// Ubah durasi threshold (2 detik) jika terlalu cepat/lambat.
  bool handleBackPress() {
    final now = DateTime.now();
    const threshold = Duration(seconds: 2); // ubah jika perlu
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
    return true; // back kedua dalam threshold → keluar
  }

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
      // logoutWithLoading() menampilkan overlay loading, await Firebase signOut,
      // lalu navigasi ke signIn — tidak perlu Get.offAllNamed manual di sini.
      onConfirm: () => _auth.logoutWithLoading(),
    );
  }
}
