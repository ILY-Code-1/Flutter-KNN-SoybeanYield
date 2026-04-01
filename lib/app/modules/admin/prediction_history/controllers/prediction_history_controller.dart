import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firestore_prediction_service.dart';
import '../models/prediction_model.dart';

class PredictionHistoryController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _predictionService = FirestorePredictionService();

  final RxList<PredictionModel> predictions = <PredictionModel>[].obs;
  final RxList<PredictionModel> filteredPredictions =
      <PredictionModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isGeneratingPdf = false.obs;
  final Rxn<PredictionModel> selectedPrediction = Rxn<PredictionModel>();

  // Date range filter
  final Rxn<DateTime> filterFrom = Rxn<DateTime>();
  final Rxn<DateTime> filterTo = Rxn<DateTime>();
  final RxString filterLabel = 'Filter Waktu Prediksi'.obs;

  @override
  void onInit() {
    super.onInit();
    loadPredictions();
  }

  Future<void> loadPredictions() async {
    isLoading.value = true;
    final result = await _predictionService.getAllPredictions();
    predictions.assignAll(result);
    _applyFilter();
    isLoading.value = false;
  }

  void _applyFilter() {
    final from = filterFrom.value;
    final to = filterTo.value;

    if (from == null && to == null) {
      filteredPredictions.assignAll(predictions);
      return;
    }

    filteredPredictions.assignAll(predictions.where((p) {
      if (from != null && p.date.isBefore(from)) return false;
      if (to != null && p.date.isAfter(to.add(const Duration(days: 1)))) {
        return false;
      }
      return true;
    }));
  }

  void showFilterSheet() {
    Get.bottomSheet(
      Builder(builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filter Waktu Prediksi',
                style: AppTextStyles.sectionTitle(context),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _dateField(context, 'Dari', true)),
                  const SizedBox(width: 12),
                  Expanded(child: _dateField(context, 'Sampai', false)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        filterFrom.value = null;
                        filterTo.value = null;
                        filterLabel.value = 'Filter Waktu Prediksi';
                        _applyFilter();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Reset',
                          style:
                              TextStyle(color: AppColors.primaryGreen)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilter();
                        final from = filterFrom.value;
                        final to = filterTo.value;
                        if (from != null || to != null) {
                          final fmt = DateFormat('dd/MM/yy');
                          filterLabel.value =
                              '${from != null ? fmt.format(from) : '...'} — ${to != null ? fmt.format(to) : '...'}';
                        } else {
                          filterLabel.value = 'Filter Waktu Prediksi';
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Terapkan',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _dateField(BuildContext context, String label, bool isFrom) {
    return Obx(() {
      final date = isFrom ? filterFrom.value : filterTo.value;
      return GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 1)),
          );
          if (picked != null) {
            if (isFrom) {
              filterFrom.value = picked;
            } else {
              filterTo.value = picked;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : label,
                  style: TextStyle(
                    fontSize: 13,
                    color: date != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void selectPrediction(PredictionModel prediction) {
    selectedPrediction.value = prediction;
    Get.toNamed(AppRoutes.adminPredictionDetail);
  }

  // ── PDF Generation ─────────────────────────────────────────────────────────

  Future<void> downloadPdf() async {
    final prediction = selectedPrediction.value;
    if (prediction == null) return;

    isGeneratingPdf.value = true;

    try {
      await initializeDateFormatting('id_ID', null);

      final pdf = pw.Document();

      // Load logo image
      pw.ImageProvider? logoImage;
      try {
        final logoBytes =
            await rootBundle.load('assets/logo.webp');
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (_) {
        // Logo not available — skip
      }

      final dateStr =
          DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(prediction.date);
      final generatedStr =
          DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(DateTime.now());

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildPdfHeader(logoImage, context),
          footer: (context) => _buildPdfFooter(context, generatedStr),
          build: (context) => [
            _buildPdfBody(prediction, dateStr),
          ],
        ),
      );

      final pdfBytes = await pdf.save();

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename:
            'prediksi_${prediction.username}_${DateFormat('yyyyMMdd').format(prediction.date)}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat membuat PDF: $e',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  pw.Widget _buildPdfHeader(
      pw.ImageProvider? logoImage, pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            if (logoImage != null) ...[
              pw.Image(logoImage, width: 50, height: 50),
              pw.SizedBox(width: 12),
            ],
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'SoybeanYield',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#2E7D32'),
                    ),
                  ),
                  pw.Text(
                    'Smart Soybean Yield Prediction System',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex('#757575'),
                    ),
                  ),
                ],
              ),
            ),
            pw.Text(
              'Laporan Hasil Prediksi',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#2E7D32'),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: PdfColor.fromHex('#2E7D32'), thickness: 1.5),
        pw.SizedBox(height: 4),
      ],
    );
  }

  pw.Widget _buildPdfFooter(pw.Context context, String generatedStr) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColor.fromHex('#BDBDBD')),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'SoybeanYield — Soybean Harvest Prediction App',
              style: pw.TextStyle(
                  fontSize: 8, color: PdfColor.fromHex('#9E9E9E')),
            ),
            pw.Text(
              'Digenerate: $generatedStr  |  Hal ${context.pageNumber}/${context.pagesCount}',
              style: pw.TextStyle(
                  fontSize: 8, color: PdfColor.fromHex('#9E9E9E')),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfBody(PredictionModel p, String dateStr) {
    final tealColor = PdfColor.fromHex('#26A69A');
    final greenColor = PdfColor.fromHex('#2E7D32');
    final bgColor = PdfColor.fromHex('#E8F5E9');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),

        // Result card
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: tealColor,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'Estimasi Hasil Panen',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 12,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                '${p.result.toStringAsFixed(3)} ton/ha',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // Info rows
        pw.Text(
          'Informasi Prediksi',
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: greenColor,
          ),
        ),
        pw.SizedBox(height: 8),
        _pdfInfoRow('Petani', p.username, bgColor),
        _pdfInfoRow(
            'Tanggal Prediksi', dateStr, PdfColors.white),
        _pdfInfoRow(
          'Hasil Panen Aktual',
          p.actualYield != null
              ? '${p.actualYield!.toStringAsFixed(3)} ton/ha'
              : '-',
          bgColor,
        ),

        pw.SizedBox(height: 20),

        pw.Text(
          'Data Input Lahan',
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: greenColor,
          ),
        ),
        pw.SizedBox(height: 8),
        _pdfInfoRow('Suhu', '${p.suhu.toStringAsFixed(1)} °C', bgColor),
        _pdfInfoRow(
            'Curah Hujan', '${p.curahHujan.toStringAsFixed(1)} mm', PdfColors.white),
        _pdfInfoRow(
            'Kelembaban', '${p.kelembaban.toStringAsFixed(1)} %', bgColor),
        _pdfInfoRow('pH Tanah', p.phTanah.toStringAsFixed(2), PdfColors.white),
        _pdfInfoRow(
            'Nitrogen', '${p.nitrogen.toStringAsFixed(1)} mg/kg', bgColor),
        _pdfInfoRow(
            'Fosfor', '${p.fosfor.toStringAsFixed(1)} mg/kg', PdfColors.white),
        _pdfInfoRow(
            'Kalium', '${p.kalium.toStringAsFixed(1)} mg/kg', bgColor),

        pw.SizedBox(height: 20),

        // Note
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColor.fromHex('#A5D6A7')),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            'Dokumen ini digenerate secara otomatis oleh sistem SoybeanYield menggunakan '
            'algoritma K-Nearest Neighbors (KNN). Hasil prediksi bersifat estimasi '
            'berdasarkan data historis.',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColor.fromHex('#616161'),
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _pdfInfoRow(String label, String value, PdfColor bg) {
    return pw.Container(
      color: bg,
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 10, color: PdfColor.fromHex('#424242'))),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#212121'))),
        ],
      ),
    );
  }

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () => _auth.logoutWithLoading(),
    );
  }
}
