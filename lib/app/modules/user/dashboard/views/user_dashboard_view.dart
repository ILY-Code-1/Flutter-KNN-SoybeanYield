import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ignore: unnecessary_import
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/user_bottom_nav.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/user_dashboard_controller.dart';
import '../widgets/info_card_widget.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // PopScope: tangkap tombol back sebelum diteruskan ke sistem.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (controller.handleBackPress()) {
          SystemNavigator.pop(); // keluar app secara native
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        // Seluruh body scrollable: header hijau + section konten scroll bersama
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Green header — menyatu dengan AppBar ──────────────────────────
              _buildHeader(context),

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
                      _buildRekapCard(context),
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
      ),
    ); // tutup PopScope
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

  Widget _buildHeader(BuildContext context) {
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
            Row(
              children: [
                Image.asset(
                  'assets/logo.webp',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 12),
                Text(
                  'Smart Soybean\n Yield Prediction',
                  style: AppTextStyles.appTitle(context),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Ambil keputusan pertanian yang lebih baik dengan wawasan berbasis data.',
              style: AppTextStyles.appSubtitle(context),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  // ── Rekap card ──────────────────────────────────────────────────────────────

  Widget _buildRekapCard(BuildContext context) {
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
          Text('Rekap Prediksi', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 2),
          Text('Prediksi Terakhir', style: AppTextStyles.inputLabel(context)),
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
                      style: AppTextStyles.chipText(context),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),

          // Stat — Total Prediksi Saya (Row: icon kiri + angka & label kanan)
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF57C00).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.totalPrediksi.value.toString(),
                        style: AppTextStyles.statValue(context),
                      ),
                      Text(
                        'Total Prediksi Saya',
                        style: AppTextStyles.statLabel(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
