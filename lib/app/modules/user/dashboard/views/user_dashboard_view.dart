import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/user_bottom_nav.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/user_dashboard_controller.dart';
import '../widgets/info_card_widget.dart';
import '../widgets/rekap_stat_card_widget.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      // Seluruh body scrollable: header hijau + section konten scroll bersama
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Green header — menyatu dengan AppBar ──────────────────────────
            _buildHeader(),

            // ── Content section — dibungkus, radius atas, overlap ke header ──
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
                    // ── Rekap Prediksi card ──────────────────────────────────
                    _buildRekapCard(),
                    const SizedBox(height: 16),

                    // ── Info card 1 — green ──────────────────────────────────
                    const InfoCardWidget(
                      title: 'Mengapa Perlu SoybeanYield ?',
                      subtitle: 'Perencanaan Lebih Baik, Hasil Lebih Optimal',
                      body:
                          'Prediksi hasil panen membantu dalam merencanakan produksi, '
                          'mengelola sumber daya, serta mengurangi risiko kerugian. '
                          'Dengan estimasi yang lebih akurat, keputusan dapat diambil '
                          'dengan lebih cepat dan tepat.',
                      accentColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 12),

                    // ── Info card 2 — orange ─────────────────────────────────
                    InfoCardWidget(
                      title: 'Mengapa Menggunakan Metode KNN?',
                      subtitle: 'Sederhana, Efektif, dan Berbasis Data',
                      body:
                          'Metode KNN bekerja dengan membandingkan data baru dengan '
                          'data sebelumnya yang memiliki karakteristik serupa. '
                          'Pendekatan ini mudah dipahami dan mampu memberikan hasil '
                          'prediksi yang konsisten.',
                      accentColor: AppColors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.userInputPrediksi),
        backgroundColor: AppColors.primaryGreen,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UserBottomNav(currentIndex: 0),
    );
  }

  // ── AppBar ──────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Iconsax.logout, color: Colors.white),
          onPressed: controller.confirmLogout,
          tooltip: 'Logout',
        ),
      ],
    );
  }

  // ── Green header section (menyatu dengan AppBar) ────────────────────────────

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
            // Logo
            Image.asset(
              'assets/logo.webp',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              'Smart Soybean Yield Prediction',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Subtitle
            Text(
              'Ambil keputusan pertanian yang lebih baik\ndengan wawasan berbasis data.',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Rekap card ──────────────────────────────────────────────────────────────

  Widget _buildRekapCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Rekap Prediksi',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Prediksi Terakhir',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),

          // Date chip
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Iconsax.calendar, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      controller.lastPredictionDate.value,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),

          // Stat cards row
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RekapStatCardWidget(
                  icon: Icons.bar_chart_rounded,
                  value: controller.totalPrediksi.value.toString(),
                  label: 'Total Prediksi\nSaya',
                ),
                RekapStatCardWidget(
                  icon: Icons.assignment_outlined,
                  value: controller.lastResult.value,
                  label: 'Prediksi\nTerakhir',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
