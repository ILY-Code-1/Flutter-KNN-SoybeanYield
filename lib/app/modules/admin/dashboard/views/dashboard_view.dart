import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/admin_bottom_nav.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/info_card_widget.dart';
import '../widgets/stat_card_widget.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow(),
            const SizedBox(height: 20),
            InfoCardWidget(
              title: 'Mengapa Perlu SoybeanYield ?',
              subtitle: 'Perencanaan Lebih Baik, Hasil Lebih Optimal',
              body:
                  'SoybeanYield membantu petani dan pemangku kepentingan pertanian dalam memprediksi hasil panen kedelai secara akurat. Dengan data berbasis teknologi, Anda dapat merencanakan kebutuhan pupuk, pengairan, dan pemasaran dengan lebih efisien, sehingga meminimalkan kerugian dan memaksimalkan keuntungan.',
              borderColor: AppColors.primaryGreen,
              titleColor: AppColors.primaryGreen,
            ),
            const SizedBox(height: 16),
            InfoCardWidget(
              title: 'Mengapa Menggunakan Metode KNN?',
              subtitle: 'Sederhana, Efektif, dan Berbasis Data',
              body:
                  'K-Nearest Neighbour (KNN) adalah algoritma machine learning yang mudah dipahami namun sangat efektif. Metode ini bekerja dengan membandingkan data input dengan data historis yang paling mirip, menghasilkan prediksi yang akurat berdasarkan pola nyata dari lapangan.',
              borderColor: AppColors.orange,
              titleColor: AppColors.orange,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.eco, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Soybean Yield Prediction',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ambil keputusan pertanian yang lebih baik dengan wawasan berbasis data.',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildStatRow() {
    return Row(
      children: [
        for (int i = 0; i < controller.stats.length; i++) ...[
          Expanded(child: StatCardWidget(stat: controller.stats[i])),
          if (i < controller.stats.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}
