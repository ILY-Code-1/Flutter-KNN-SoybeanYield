import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/fullscreen_app_bar.dart';
import '../../history/models/user_prediction_model.dart';
import '../widgets/detail_row_widget.dart';

/// Detail screen — all data arrives via [Get.arguments] as a
/// [UserPredictionModel]. Works for both fresh predictions and history taps.
class PredictionDetailUserView extends StatefulWidget {
  const PredictionDetailUserView({super.key});

  @override
  State<PredictionDetailUserView> createState() =>
      _PredictionDetailUserViewState();
}

class _PredictionDetailUserViewState extends State<PredictionDetailUserView> {
  final TextEditingController _hasilPanenAktualController =
      TextEditingController();

  @override
  void dispose() {
    _hasilPanenAktualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Get.arguments as UserPredictionModel;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FullscreenAppBar(),
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
                  style: AppTextStyles.appTitle(context),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detail hasil prediksi dan input data lahan',
                  style: AppTextStyles.appSubtitle(context),
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
                    style: AppTextStyles.sectionTitle(context)
                        .copyWith(color: AppColors.primaryGreen),
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
                          style: AppTextStyles.resultValue(context),
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
                      style: AppTextStyles.sectionTitle(context),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Input detail card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.black.withValues(alpha: 0.5), width: 1),
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
                          label: 'Kelembaban',
                          value: '${model.kelembaban.toStringAsFixed(0)}%',
                        ),
                        DetailRowWidget(
                          label: 'pH Tanah',
                          value: model.phTanah.toStringAsFixed(1),
                        ),
                        DetailRowWidget(
                          label: 'Nitrogen',
                          value: '${model.nitrogen.toStringAsFixed(0)} mg/kg',
                        ),
                        DetailRowWidget(
                          label: 'Fosfor',
                          value: '${model.fosfor.toStringAsFixed(0)} mg/kg',
                        ),
                        DetailRowWidget(
                          label: 'Kalium',
                          value: '${model.kalium.toStringAsFixed(0)} mg/kg',
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
                      style: AppTextStyles.sectionTitle(context),
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
                          style: AppTextStyles.chipText(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section: Data Hasil Panen Aktual
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Data Hasil Panen Aktual',
                      style: AppTextStyles.sectionTitle(context),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Aktual harvest input — same color as tanggal prediksi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.chart_21,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _hasilPanenAktualController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: AppTextStyles.chipText(context),
                            decoration: InputDecoration(
                              hintText: 'e.g. 2.5',
                              hintStyle: AppTextStyles.chipText(context)
                                  .copyWith(color: Colors.white60),
                              suffixText: 'ton/ha',
                              suffixStyle: AppTextStyles.inputLabel(context)
                                  .copyWith(color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Simpan Hasil Panen Aktual button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _hasilPanenAktualController.text.isEmpty
                          ? null
                          : () {
                              final nilai =
                                  _hasilPanenAktualController.text.trim();
                              if (nilai.isEmpty ||
                                  double.tryParse(nilai) == null) {
                                Get.snackbar(
                                  'Data Tidak Valid',
                                  'Masukkan angka yang valid untuk hasil panen aktual',
                                  backgroundColor: Colors.red.shade400,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: const EdgeInsets.all(16),
                                );
                                return;
                              }
                              Get.snackbar(
                                'Berhasil',
                                'Hasil panen aktual $nilai ton/ha telah disimpan',
                                backgroundColor: AppColors.primaryGreen,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                                margin: const EdgeInsets.all(16),
                              );
                            },
                      icon: const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Simpan Hasil Panen Aktual',
                        style: AppTextStyles.buttonText(context),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _hasilPanenAktualController.text.isEmpty
                                ? Colors.grey
                                : AppColors.primaryGreen,
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
    );
  }

}
