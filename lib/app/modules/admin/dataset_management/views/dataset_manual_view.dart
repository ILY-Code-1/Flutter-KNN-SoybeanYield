import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/admin_bottom_nav.dart';
import '../controllers/dataset_management_controller.dart';
import '../widgets/dataset_form_field_widget.dart';

class DatasetManualView extends GetView<DatasetManagementController> {
  const DatasetManualView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Green header ─────────────────────────────────────────────────
            _buildHeader(),

            // ── Content section ───────────────────────────────────────────────
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DatasetFormFieldWidget(
                        label: 'Suhu - Celcius',
                        hint: 'e.g. 29',
                        controller: controller.suhuController,
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'Curah Hujan - mm',
                        hint: 'e.g. 900',
                        controller: controller.curahHujanController,
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'Kelembaban - Presentase',
                        hint: 'e.g. 75',
                        controller: controller.kelembabanController,
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'pH Tanah',
                        hint: 'e.g. 6.4',
                        controller: controller.phTanahController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'Nitrogen - (mg/kg)',
                        hint: 'e.g. 35',
                        controller: controller.nitrogenController,
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'Fosfor - (mg/kg)',
                        hint: 'e.g. 20',
                        controller: controller.fosforController,
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'Kalium - (mg/kg)',
                        hint: 'e.g. 150',
                        controller: controller.kaliumController,
                      ),
                      const SizedBox(height: 16),
                      DatasetFormFieldWidget(
                        label: 'Hasil Panen - Ton/Ha',
                        hint: 'e.g. 2.94',
                        controller: controller.hasilPanenController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── SIMPAN DATASET button ─────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: controller.validateAndSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'SIMPAN DATASET',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF212121),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Colors.white),
        onPressed: () => Get.back(),
      ),
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Input Dataset',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Masukan data untuk menambah akurasi\nprediksi hasil panen.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
