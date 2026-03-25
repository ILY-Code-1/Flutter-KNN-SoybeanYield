import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

/// Bottom navigation bar for the User (Petani) role.
///
/// Uses a [BottomAppBar] with a [CircularNotchedRectangle] shape so a
/// [FloatingActionButton] docked at [FloatingActionButtonLocation.centerDocked]
/// sits seamlessly in the centre notch.
///
/// Each screen that uses this widget must also declare:
/// ```dart
/// floatingActionButton: FloatingActionButton(
///   onPressed: () => Get.toNamed(AppRoutes.userInputPrediksi),
///   backgroundColor: AppColors.primaryGreen,
///   child: const Icon(Icons.add_rounded, color: Colors.white),
/// ),
/// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
/// ```
class UserBottomNav extends StatelessWidget {
  /// 0 = Home, 2 = Riwayat  (index 1 is the FAB — not a real tab)
  final int currentIndex;

  const UserBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            // ── Home ──────────────────────────────────────────────────────────
            Expanded(
              child: _NavItem(
                icon: Iconsax.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) {
                    Get.offAllNamed(AppRoutes.userDashboard);
                  }
                },
              ),
            ),
            // Gap for the centre FAB notch
            const Expanded(child: SizedBox()),
            // ── Riwayat ───────────────────────────────────────────────────────
            Expanded(
              child: _NavItem(
                icon: Iconsax.clock,
                label: 'Riwayat',
                isActive: currentIndex == 2,
                onTap: () {
                  if (currentIndex != 2) {
                    Get.offAllNamed(AppRoutes.userHistory);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.primaryGreen : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: color,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
