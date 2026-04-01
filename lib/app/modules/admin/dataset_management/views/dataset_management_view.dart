import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/admin_bottom_nav.dart';
import '../controllers/dataset_management_controller.dart';
import '../widgets/dataset_table_widget.dart';

class DatasetManagementView extends GetView<DatasetManagementController> {
  const DatasetManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Green header ─────────────────────────────────────────────────
            _buildHeader(context),

            // ── Content section ───────────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                ),
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
                    _buildUploadButton(context),
                    const SizedBox(height: 12),
                    _buildManualButton(context),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        );
                      }
                      return DatasetTableWidget(
                        datasets: controller.datasets.toList(),
                        onDelete: (dataset) =>
                            controller.confirmDelete(dataset.id),
                      );
                    }),
                  ],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kelola Dataset', style: AppTextStyles.appTitle(context)),
          const SizedBox(height: 4),
          Text(
            'Kelola dataset untuk memastikan prediksi\ntetap akurat.',
            style: AppTextStyles.appSubtitle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: controller.openUploadDataset,
        icon: const Icon(Icons.file_upload_outlined,
            color: AppColors.primaryGreen),
        label: Text(
          'Upload Dataset',
          style: AppTextStyles.cardLabel(context)
              .copyWith(color: AppColors.primaryGreen),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildManualButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: controller.openManualInput,
        icon: const Icon(Icons.add_rounded, color: Color(0xFF212121)),
        label: Text(
          'Tambah Data Manual',
          style: AppTextStyles.cardLabel(context).copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
