import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';
import '../models/dataset_model.dart';

class DatasetTableWidget extends StatelessWidget {
  final List<DatasetModel> datasets;

  const DatasetTableWidget({super.key, required this.datasets});

  static const List<String> _headers = [
    'Suhu',
    'Curah Hujan',
    'pH',
    'Nitrogen',
    'Fosfor',
    'Kalium',
    'Hasil Panen',
  ];

  static const Map<int, TableColumnWidth> _columnWidths = {
    0: FixedColumnWidth(72),
    1: FixedColumnWidth(104),
    2: FixedColumnWidth(58),
    3: FixedColumnWidth(80),
    4: FixedColumnWidth(70),
    5: FixedColumnWidth(70),
    6: FixedColumnWidth(96),
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
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
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
                          .map((h) => _headerCell(h))
                          .toList(),
                    ),
                    // Data rows
                    ...datasets.map(
                      (d) => TableRow(
                        children: [
                          _dataCell(d.suhu.toStringAsFixed(0)),
                          _dataCell(d.curahHujan.toStringAsFixed(0)),
                          _dataCell(d.phTanah.toStringAsFixed(1)),
                          _dataCell(d.nitrogen.toStringAsFixed(0)),
                          _dataCell(d.fosfor.toStringAsFixed(0)),
                          _dataCell(d.kalium.toStringAsFixed(0)),
                          _dataCell(
                              '${d.hasilPanen.toStringAsFixed(2)} t'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _dataCell(String text) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
