import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ignore: unnecessary_import
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/admin_bottom_nav.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/info_card_widget.dart';
import '../widgets/stat_card_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // PopScope: tangkap tombol back sebelum diteruskan ke sistem.
    // canPop: false → selalu tahan back, lalu putuskan via onPopInvokedWithResult.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return; // sudah diproses, abaikan
        // handleBackPress() return true jika back kedua → izinkan keluar manual
        if (controller.handleBackPress()) {
          // SystemNavigator.pop() menutup app secara native (Android back-stack)
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Green header — menyatu dengan AppBar ──────────────────────────
              _buildHeader(),

              // ── Content section — radius atas, overlap ke header ─────────────
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan Terkini',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatRow(),
                      const SizedBox(height: 20),
                      InfoCardWidget(
                        title: 'Mengapa Perlu SoybeanYield ?',
                        subtitle: 'Perencanaan Lebih Baik, Hasil Lebih Optimal',
                        body:
                            'SoybeanYield membantu petani dan pemangku kepentingan pertanian dalam memprediksi hasil panen kedelai secara akurat. Dengan data berbasis teknologi, Anda dapat merencanakan kebutuhan pupuk, pengairan, dan pemasaran dengan lebih efisien, sehingga meminimalkan kerugian dan memaksimalkan keuntungan.',
                        borderColor: AppColors.primaryGreen,
                        titleColor: AppColors.primaryGreen,
                      ),
                      const SizedBox(height: 16),
                      InfoCardWidget(
                        title: 'Mengapa Menggunakan Metode KNN?',
                        subtitle: 'Sederhana, Efektif, dan Berbasis Data',
                        body:
                            'K-Nearest Neighbour (KNN) adalah algoritma machine learning yang mudah dipahami namun sangat efektif. Metode ini bekerja dengan membandingkan data input dengan data historis yang paling mirip, menghasilkan prediksi yang akurat berdasarkan pola nyata dari lapangan.',
                        borderColor: AppColors.orange,
                        titleColor: AppColors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
      ),
    ); // tutup PopScope
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Iconsax.logout, color: Colors.white),
          onPressed: controller.logout,
          tooltip: 'Logout',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.webp',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              'Smart Soybean Yield Prediction',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ambil keputusan pertanian yang lebih baik\ndengan wawasan berbasis data.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      children: [
        for (int i = 0; i < controller.stats.length; i++) ...[
          Expanded(child: StatCardWidget(stat: controller.stats[i])),
          if (i < controller.stats.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
