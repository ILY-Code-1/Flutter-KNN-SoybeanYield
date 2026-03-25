import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/user_bottom_nav.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/prediction_controller.dart';
import '../widgets/input_field_widget.dart';

class InputPrediksiView extends GetView<PredictionController> {
  const InputPrediksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Green header ─────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INPUT DATA LAHAN',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Masukan Data Lahan Sebelum Untuk Memulai Prediksi',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable form ──────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InputFieldWidget(
                      label: 'Suhu - Celcius',
                      hint: 'e.g. 29',
                      controller: controller.suhuController,
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'Curah Hujan - mm',
                      hint: 'e.g. 900',
                      controller: controller.curahHujanController,
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'Kelembaban - Presentase',
                      hint: 'e.g. 75',
                      controller: controller.kelembabanController,
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'pH Tanah',
                      hint: 'e.g. 6.4',
                      controller: controller.phTanahController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'Nitrogen - (mg/kg)',
                      hint: 'e.g. 35',
                      controller: controller.nitrogenController,
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'Fosfor - (mg/kg)',
                      hint: 'e.g. 20',
                      controller: controller.fosforController,
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'Kalium - (mg/kg)',
                      hint: 'e.g. 150',
                      controller: controller.kaliumController,
                    ),
                    const SizedBox(height: 16),
                    InputFieldWidget(
                      label: 'Hasil Panen - Ton/Ha',
                      hint: 'e.g. 2.94',
                      controller: controller.hasilPanenController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 28),

                    // ── HITUNG PREDIKSI button ────────────────────────────────
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.validateAndPredict,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            disabledBackgroundColor: const Color(0xFFFFE082),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  'HITUNG PREDIKSI',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF212121),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
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
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
      ),
      actions: const [SizedBox(width: 8)],
    );
  }
}
