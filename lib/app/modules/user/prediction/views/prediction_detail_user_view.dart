import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/user_bottom_nav.dart';
import '../../../../routes/app_routes.dart';
import '../../history/models/user_prediction_model.dart';
import '../widgets/detail_row_widget.dart';

/// Stateless detail screen — all data arrives via [Get.arguments] as a
/// [UserPredictionModel]. Works for both fresh predictions and history taps.
class PredictionDetailUserView extends StatelessWidget {
  const PredictionDetailUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.arguments as UserPredictionModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Green header ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Predictions Detail',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Unduh dan bagikan hasil prediksi',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable body ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section: Estimasi Hasil Panen
                  Text(
                    'Estimasi Hasil Panen',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Gradient result card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accentTeal, AppColors.primaryGreen],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentTeal.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.activity,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${model.result} ton/ha',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section: Detail Input
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Detail Input',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Input detail card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        DetailRowWidget(
                          label: 'Suhu',
                          value: '${model.suhu.toStringAsFixed(0)}°C',
                        ),
                        DetailRowWidget(
                          label: 'Curah Hujan',
                          value: '${model.curahHujan.toStringAsFixed(0)} mm',
                        ),
                        DetailRowWidget(
                          label: 'pH Tanah',
                          value: model.phTanah.toStringAsFixed(1),
                        ),
                        DetailRowWidget(
                          label: 'Nitrogen',
                          value:
                              '${model.nitrogen.toStringAsFixed(0)} mg/kg',
                        ),
                        DetailRowWidget(
                          label: 'Fosfor',
                          value:
                              '${model.fosfor.toStringAsFixed(0)} mg/kg',
                        ),
                        DetailRowWidget(
                          label: 'Kalium',
                          value:
                              '${model.kalium.toStringAsFixed(0)} mg/kg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section: Tanggal Prediksi
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tanggal Prediksi',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date chip — full width
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.calendar,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('dd/MM/yyyy').format(model.date),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Download button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          'Info',
                          'Fitur unduh segera hadir',
                          backgroundColor: AppColors.primaryGreen,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(16),
                        );
                      },
                      icon: const Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Unduh Hasil Prediksi',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.userInputPrediksi),
        backgroundColor: AppColors.primaryGreen,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UserBottomNav(currentIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 110,
      leading: TextButton.icon(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: 16,
        ),
        label: Text(
          'Kembali',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
        ),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
      ),
      actions: const [SizedBox(width: 8)],
    );
  }
}
