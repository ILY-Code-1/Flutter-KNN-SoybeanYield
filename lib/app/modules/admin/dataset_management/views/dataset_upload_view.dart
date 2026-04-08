import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/fullscreen_app_bar.dart';
import '../controllers/dataset_management_controller.dart';

class DatasetUploadView extends GetView<DatasetManagementController> {
  const DatasetUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FullscreenAppBar(),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Tutorial section ───────────────────────────────────
                      _buildTutorialSection(context),
                      const SizedBox(height: 20),

                      // ── Upload zone — tap untuk buka file manager ──────────
                      GestureDetector(
                        onTap: controller.pickFile,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFA5D6A7),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 52,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Pilih File Dataset',
                                style: AppTextStyles.sectionTitle(context)
                                    .copyWith(color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Tap untuk membuka file manager (.txt / .csv)',
                                style: AppTextStyles.inputLabel(context),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Buka File Manager',
                                  style: AppTextStyles.badgeText(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Selected file indicator ───────────────────────────
                      Obx(() {
                        final fileName = controller.selectedFileName.value;
                        if (fileName == null) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primaryGreen,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_drive_file_outlined,
                                color: AppColors.primaryGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  fileName,
                                  style: AppTextStyles.detailLabel(context)
                                      .copyWith(color: AppColors.primaryGreen),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.selectedFileName.value = null;
                                  controller.selectedFilePath.value = null;
                                },
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 28),

                      // ── SIMPAN DATASET button ─────────────────────────────
                      Obx(() => SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isUploading.value
                                  ? null
                                  : controller.saveUploadedFile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC107),
                                disabledBackgroundColor:
                                    const Color(0xFFFFE082),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: controller.isUploading.value
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.black54,
                                            strokeWidth: 2.5,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Mengupload...',
                                          style: TextStyle(
                                              color: Color(0xFF212121)),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'SIMPAN DATASET',
                                      style: AppTextStyles.buttonText(context)
                                          .copyWith(
                                              color: const Color(0xFF212121)),
                                    ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Title ──
        Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                color: AppColors.primaryGreen, size: 18),
            const SizedBox(width: 6),
            Text(
              'Panduan Menyiapkan File Dataset',
              style: AppTextStyles.sectionTitle(context)
                  .copyWith(fontSize: 13, color: AppColors.primaryGreen),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // ── Format info box ──
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F8E9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFA5D6A7), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tutorialItem(context, '1',
                  'Format file: TXT atau CSV dengan pemisah koma (,)'),
              _tutorialItem(context, '2',
                  'Baris pertama boleh berisi header (akan dilewati otomatis)'),
              _tutorialItem(context, '3',
                  'Urutan kolom harus sesuai:\nsuhu, curah_hujan, kelembaban, ph_tanah, nitrogen, fosfor, kalium, hasil_panen'),
              _tutorialItem(context, '4', 'Satuan masing-masing kolom:',
                  detail: true),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 4, bottom: 2),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.4),
                    1: FlexColumnWidth(1),
                  },
                  children: const [
                    TableRow(children: [
                      _TableCell(text: 'Suhu', bold: true),
                      _TableCell(text: '°C'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'Curah Hujan', bold: true),
                      _TableCell(text: 'mm'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'Kelembaban', bold: true),
                      _TableCell(text: '%'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'pH Tanah', bold: true),
                      _TableCell(text: '- (tanpa satuan, misal: 6.5)'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'Nitrogen', bold: true),
                      _TableCell(text: 'mg/kg'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'Fosfor', bold: true),
                      _TableCell(text: 'mg/kg'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'Kalium', bold: true),
                      _TableCell(text: 'mg/kg'),
                    ]),
                    TableRow(children: [
                      _TableCell(text: 'Hasil Panen', bold: true),
                      _TableCell(text: 't/ha'),
                    ]),
                  ],
                ),
              ),
              _tutorialItem(context, '5',
                  'Contoh baris data:\n28,850,70,6.5,40,20,150,2.50'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Download sample button ──
        OutlinedButton.icon(
          onPressed: controller.downloadSampleFile,
          icon: const Icon(Icons.download_rounded,
              color: AppColors.primaryGreen, size: 18),
          label: Text(
            'Download Contoh File Dataset',
            style: AppTextStyles.inputLabel(context)
                .copyWith(color: AppColors.primaryGreen),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _tutorialItem(BuildContext context, String number, String text,
      {bool detail = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.detailLabel(context).copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
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
          Text('Upload Dataset', style: AppTextStyles.appTitle(context)),
          const SizedBox(height: 4),
          Text(
            'Pilih file dataset dari penyimpanan perangkat.',
            style: AppTextStyles.appSubtitle(context),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool bold;

  const _TableCell({required this.text, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          color: const Color(0xFF424242),
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
