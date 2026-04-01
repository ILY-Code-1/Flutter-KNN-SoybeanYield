import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/fullscreen_app_bar.dart';
import '../../../../global_widgets/primary_button.dart';
import '../controllers/prediction_history_controller.dart';
import '../widgets/detail_row_widget.dart';

class PredictionDetailView extends GetView<PredictionHistoryController> {
  const PredictionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FullscreenAppBar(),
      body: Obx(() {
        final prediction = controller.selectedPrediction.value;
        if (prediction == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              // ── Green header ───────────────────────────────────────────────
              _buildHeader(context),

              // ── Content section ────────────────────────────────────────────
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
                      // ── Estimasi Hasil Panen ───────────────────────────────
                      Center(
                        child: Text(
                          'Estimasi Hasil Panen',
                          style: AppTextStyles.sectionTitle(context)
                              .copyWith(color: AppColors.primaryGreen),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildResultCard(context, prediction.result),
                      const SizedBox(height: 24),

                      // ── Detail Input ───────────────────────────────────────
                      Text(
                        'Detail Input',
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      const SizedBox(height: 10),
                      _buildInputDetailCard(context, prediction),
                      const SizedBox(height: 24),

                      // ── Tanggal Prediksi ───────────────────────────────────
                      Text(
                        'Tanggal Prediksi',
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoChip(
                        context: context,
                        icon: Iconsax.calendar,
                        text: DateFormat('dd/MM/yyyy, HH:mm')
                            .format(prediction.date),
                      ),
                      const SizedBox(height: 20),

                      // ── Pembuat Prediksi ───────────────────────────────────
                      Text(
                        'Pembuat Prediksi',
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoChip(
                        context: context,
                        icon: Iconsax.user,
                        text: prediction.username,
                      ),
                      const SizedBox(height: 20),

                      // ── Data Hasil Panen Aktual (read-only) ────────────────
                      Text(
                        'Data Hasil Panen Aktual',
                        style: AppTextStyles.sectionTitle(context),
                      ),
                      const SizedBox(height: 10),
                      _buildActualYieldChip(context, prediction.actualYield),
                      const SizedBox(height: 28),

                      // ── Download PDF button (admin only) ───────────────────
                      Obx(() => PrimaryButton(
                            text: 'Download PDF',
                            onPressed: controller.downloadPdf,
                            isLoading: controller.isGeneratingPdf.value,
                            backgroundColor: AppColors.primaryGreen,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
          Text('Detail Prediksi', style: AppTextStyles.appTitle(context)),
          const SizedBox(height: 4),
          Text(
            'Detail hasil prediksi dan input data lahan.',
            style: AppTextStyles.appSubtitle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, double result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26A69A), Color(0xFF2E7D32)],
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${result.toStringAsFixed(3)} ton/ha',
                style: AppTextStyles.resultValue(context),
              ),
              Text(
                'Estimasi hasil panen kedelai',
                style: AppTextStyles.appSubtitle(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputDetailCard(BuildContext context, dynamic prediction) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          DetailRowWidget(
              label: 'Suhu',
              value: '${prediction.suhu.toStringAsFixed(1)}°C'),
          const SizedBox(height: 10),
          DetailRowWidget(
              label: 'Curah Hujan',
              value: '${prediction.curahHujan.toStringAsFixed(1)} mm'),
          const SizedBox(height: 10),
          DetailRowWidget(
              label: 'Kelembaban',
              value: '${prediction.kelembaban.toStringAsFixed(1)}%'),
          const SizedBox(height: 10),
          DetailRowWidget(
              label: 'pH Tanah',
              value: prediction.phTanah.toStringAsFixed(2)),
          const SizedBox(height: 10),
          DetailRowWidget(
              label: 'Nitrogen',
              value: '${prediction.nitrogen.toStringAsFixed(1)} mg/kg'),
          const SizedBox(height: 10),
          DetailRowWidget(
              label: 'Fosfor',
              value: '${prediction.fosfor.toStringAsFixed(1)} mg/kg'),
          const SizedBox(height: 10),
          DetailRowWidget(
              label: 'Kalium',
              value: '${prediction.kalium.toStringAsFixed(1)} mg/kg'),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.chipText(context))),
        ],
      ),
    );
  }

  Widget _buildActualYieldChip(BuildContext context, double? actualYield) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: actualYield != null
            ? AppColors.accentTeal
            : AppColors.textSecondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Iconsax.chart_21,
            color: actualYield != null ? Colors.white : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            actualYield != null
                ? '${actualYield.toStringAsFixed(3)} ton/ha'
                : '-',
            style: AppTextStyles.chipText(context).copyWith(
              color: actualYield != null
                  ? Colors.white
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
