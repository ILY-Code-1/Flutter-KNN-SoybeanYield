import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Semua text style terpusat di sini.
///
/// Setiap method menerima [BuildContext] agar bisa membaca lebar layar via
/// [MediaQuery] dan menerapkan scaling factor otomatis.
///
/// **Cara pakai:**
/// ```dart
/// Text('Judul', style: AppTextStyles.appTitle(context))
/// Text('Label', style: AppTextStyles.cardLabel(context).copyWith(color: accentColor))
/// ```
class AppTextStyles {
  AppTextStyles._();

  // ── Responsive scaling ────────────────────────────────────────────────────
  //
  // Reference design width: 390px (iPhone 14 / Pixel 7).
  // Factor di-clamp antara 0.85× (layar kecil ~330px) hingga 1.2× (tablet).
  // Contoh: sp(context, 16) → 13.6px pada 330px, 16px pada 390px, 19.2px pada 468px.
  static double _sp(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    final factor = (width / 390).clamp(0.85, 1.2);
    return size * factor;
  }

  // ── Header halaman (AppBar + green header) ────────────────────────────────

  /// Judul utama halaman di header hijau. Contoh: "INPUT DATA LAHAN".
  static TextStyle appTitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 25),
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        letterSpacing: 0.3,
      );

  /// Subjudul di bawah judul halaman pada header hijau.
  static TextStyle appSubtitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 15),
        fontWeight: FontWeight.w400,
        color: AppColors.white.withValues(alpha: 0.85),
        height: 1.5,
      );

  // ── Section & card ────────────────────────────────────────────────────────

  /// Judul section di dalam card. Contoh: "Detail Input", "Rekap Prediksi".
  static TextStyle sectionTitle(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 16),
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  /// Label standar di dalam card. Contoh: "Tanggal Prediksi", tanggal di history.
  static TextStyle cardLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // ── Body / secondary ──────────────────────────────────────────────────────

  /// Teks paragraf panjang. Contoh: isi InfoCard.
  static TextStyle bodyText(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  /// Label kecil sekunder. Contoh: "Prediksi Terakhir" di rekap card.
  static TextStyle inputLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Tombol ────────────────────────────────────────────────────────────────

  /// Teks tombol utama berwarna terang. Contoh: "Simpan Hasil Panen Aktual".
  static TextStyle buttonText(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 15),
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        letterSpacing: 1.0,
      );

  // ── Badge / chip / pill ───────────────────────────────────────────────────

  /// Teks di dalam pill/badge kecil. Contoh: "2.94 ton" di history card.
  static TextStyle badgeText(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 12),
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );

  /// Teks di chip tanggal / chip teal. Lebih besar dari badge.
  static TextStyle chipText(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      );

  // ── Stat card (angka besar di dashboard) ─────────────────────────────────

  /// Angka besar di stat card. Contoh: "12" (total prediksi).
  static TextStyle statValue(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 36),
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        height: 1.1,
      );

  /// Label di bawah angka besar. Contoh: "Total Prediksi Saya".
  static TextStyle statLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.white.withValues(alpha: 0.9),
      );

  // ── Hasil prediksi ────────────────────────────────────────────────────────

  /// Nilai hasil KNN besar di prediction detail. Contoh: "2.94 ton/ha".
  static TextStyle resultValue(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 28),
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      );

  // ── Detail row (kartu detail input) ──────────────────────────────────────

  /// Label kiri di DetailRowWidget. Contoh: "Suhu", "pH Tanah".
  static TextStyle detailLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  /// Nilai kanan di DetailRowWidget. Contoh: "29°C", "6.4".
  static TextStyle detailValue(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  // ── Input field ───────────────────────────────────────────────────────────

  /// Label di atas TextField. Contoh: "Suhu - Celcius".
  static TextStyle inputFieldLabel(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  /// Teks yang diketik user di dalam TextField.
  static TextStyle inputFieldText(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 14),
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  /// Placeholder/hint di dalam TextField.
  static TextStyle inputFieldHint(BuildContext context) => GoogleFonts.poppins(
        fontSize: _sp(context, 13),
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );
}
