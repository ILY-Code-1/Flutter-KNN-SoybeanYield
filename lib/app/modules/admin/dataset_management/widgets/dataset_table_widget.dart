import 'package:flutter/material.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../models/dataset_model.dart';

class DatasetTableWidget extends StatelessWidget {
  final List<DatasetModel> datasets;

  /// Dipanggil saat icon delete ditekan. Beri null untuk menonaktifkan kolom aksi.
  final void Function(DatasetModel dataset)? onDelete;

  const DatasetTableWidget({
    super.key,
    required this.datasets,
    this.onDelete,
  });

  static const List<String> _headers = [
    'No',
    'Suhu\n(°C)',
    'Curah\nHujan\n(mm)',
    'Kelembaban\n(%)',
    'pH\n(-)',
    'Nitrogen\n(mg/kg)',
    'Fosfor\n(mg/kg)',
    'Kalium\n(mg/kg)',
    'Hasil\nPanen\n(t/ha)',
    'Aksi',
  ];

  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(36),  // No
    1: FixedColumnWidth(56),  // Suhu
    2: FixedColumnWidth(72),  // Curah Hujan
    3: FixedColumnWidth(80),  // Kelembaban
    4: FixedColumnWidth(48),  // pH
    5: FixedColumnWidth(68),  // Nitrogen
    6: FixedColumnWidth(60),  // Fosfor
    7: FixedColumnWidth(60),  // Kalium
    8: FixedColumnWidth(72),  // Hasil Panen
    9: FixedColumnWidth(48),  // Aksi
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: datasets.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Belum ada data',
                    style: AppTextStyles.inputLabel(context),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  border: TableBorder.all(
                    color: AppColors.divider,
                    width: 0.5,
                    borderRadius: BorderRadius.zero,
                  ),
                  columnWidths: _columnWidths,
                  children: [
                    // Header row
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F8E9),
                      ),
                      children: _headers
                          .map((h) => _headerCell(context, h))
                          .toList(),
                    ),
                    // Data rows
                    ...datasets.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final d = entry.value;
                        return TableRow(
                          children: [
                            _dataCell(context, '${index + 1}'),
                            _dataCell(context, d.suhu.toStringAsFixed(0)),
                            _dataCell(context, d.curahHujan.toStringAsFixed(0)),
                            _dataCell(context, d.kelembaban.toStringAsFixed(0)),
                            _dataCell(context, d.phTanah.toStringAsFixed(1)),
                            _dataCell(context, d.nitrogen.toStringAsFixed(0)),
                            _dataCell(context, d.fosfor.toStringAsFixed(0)),
                            _dataCell(context, d.kalium.toStringAsFixed(0)),
                            _dataCell(context,
                                d.hasilPanen.toStringAsFixed(2)),
                            _actionCell(context, d),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _headerCell(BuildContext context, String text) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: AppTextStyles.detailLabel(context).copyWith(fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dataCell(BuildContext context, String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: AppTextStyles.detailValue(context).copyWith(fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _actionCell(BuildContext context, DatasetModel dataset) {
    return SizedBox(
      height: 40,
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.deleteRed,
            size: 18,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: 'Hapus',
          onPressed: onDelete != null ? () => onDelete!(dataset) : null,
        ),
      ),
    );
  }
}
