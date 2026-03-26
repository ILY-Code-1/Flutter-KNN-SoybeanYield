import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/user_dashboard_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';

class UserDashboardController extends GetxController {
  final _auth = Get.find<AuthController>();

  // ── Double back to exit ────────────────────────────────────────────────────
  DateTime? _lastBackPress;

  /// Dipanggil dari PopScope di UserDashboardView.
  /// Return true  → izinkan app keluar.
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
    return true;
  }

  final RxInt totalPrediksi = 0.obs;
  final RxString lastResult = ''.obs;
  final RxString lastPredictionDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    totalPrediksi.value = UserDashboardDummy.totalPrediksi;
    lastResult.value = UserDashboardDummy.prediksiTerakhir;
    lastPredictionDate.value =
        DateFormat('dd MMM yyyy').format(UserDashboardDummy.tanggalTerakhir);
  }

  void confirmLogout() {
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
