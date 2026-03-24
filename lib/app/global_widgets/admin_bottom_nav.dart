import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      backgroundColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
      onTap: (index) {
        if (index == currentIndex) return;
        switch (index) {
          case 0:
            Get.offAllNamed(AppRoutes.adminDashboard);
            break;
          case 1:
            Get.offAllNamed(AppRoutes.adminUserManagement);
            break;
          case 2:
            Get.offAllNamed(AppRoutes.adminDatasetManagement);
            break;
          case 3:
            Get.offAllNamed(AppRoutes.adminPredictionHistory);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.people),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.storage_outlined),
          label: 'Dataset',
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.clock),
          label: 'Riwayat',
        ),
      ],
    );
  }
}
