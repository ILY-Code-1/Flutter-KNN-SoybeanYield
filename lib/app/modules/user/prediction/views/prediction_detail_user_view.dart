import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/fullscreen_app_bar.dart';
import '../../../../services/firestore_dataset_service.dart';
import '../../../../services/firestore_prediction_service.dart';
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
  final _predictionService = FirestorePredictionService();
  final _datasetService = FirestoreDatasetService();

  bool _isSaving = false;

  late UserPredictionModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.arguments as UserPredictionModel;

    // Pre-fill actual yield if already set
    if (_model.actualYield != null) {
      _hasilPanenAktualController.text =
          _model.actualYield!.toStringAsFixed(3);
    }
  }

  @override
  void dispose() {
    _hasilPanenAktualController.dispose();
    super.dispose();
  }

  Future<void> _saveActualYield() async {
    final text = _hasilPanenAktualController.text.trim();
    final nilai = double.tryParse(text);
    if (nilai == null) {
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

    setState(() => _isSaving = true);

    try {
      // 1. Update actual_yield in soybean_prediction
      final predOk =
          await _predictionService.updateActualYield(_model.id, nilai);

      // 2. Add/update dataset_soybean with the actual yield
      final datasetOk = await _datasetService.addOrUpdateByInputs(
        suhu: _model.suhu,
        curahHujan: _model.curahHujan,
        kelembaban: _model.kelembaban,
        phTanah: _model.phTanah,
        nitrogen: _model.nitrogen,
        fosfor: _model.fosfor,
        kalium: _model.kalium,
        hasilPanen: nilai,
      );

      setState(() {
        _isSaving = false;
        _model = _model.copyWith(actualYield: nilai);
      });

      if (predOk && datasetOk) {
        Get.snackbar(
          'Berhasil',
          'Hasil panen aktual $nilai ton/ha telah disimpan dan dataset diperbarui.',
          backgroundColor: AppColors.primaryGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Sebagian Gagal',
          'Hasil aktual disimpan, namun terjadi masalah memperbarui dataset.',
          backgroundColor: Colors.orange.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Detail Prediksi',
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
                          '${_model.result} ton/ha',
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
                          value: '${_model.suhu.toStringAsFixed(1)}°C',
                        ),
                        DetailRowWidget(
                          label: 'Curah Hujan',
                          value: '${_model.curahHujan.toStringAsFixed(1)} mm',
                        ),
                        DetailRowWidget(
                          label: 'Kelembaban',
                          value: '${_model.kelembaban.toStringAsFixed(1)}%',
                        ),
                        DetailRowWidget(
                          label: 'pH Tanah',
                          value: _model.phTanah.toStringAsFixed(2),
                        ),
                        DetailRowWidget(
                          label: 'Nitrogen',
                          value:
                              '${_model.nitrogen.toStringAsFixed(1)} mg/kg',
                        ),
                        DetailRowWidget(
                          label: 'Fosfor',
                          value:
                              '${_model.fosfor.toStringAsFixed(1)} mg/kg',
                        ),
                        DetailRowWidget(
                          label: 'Kalium',
                          value:
                              '${_model.kalium.toStringAsFixed(1)} mg/kg',
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

                  // Date chip
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
                          DateFormat('dd/MM/yyyy, HH:mm').format(_model.date),
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

                  // Aktual harvest input
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
                            onChanged: (_) => setState(() {}),
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
                      onPressed: (_hasilPanenAktualController.text.isEmpty ||
                              _isSaving)
                          ? null
                          : _saveActualYield,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                            ),
                      label: Text(
                        _isSaving
                            ? 'Menyimpan...'
                            : 'Simpan Hasil Panen Aktual',
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
