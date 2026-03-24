import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../constants/app_colors.dart';
import '../models/user_model.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserCardWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor =
        user.isAdmin ? AppColors.orange : AppColors.userBadgeGreen;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: badgeColor.withValues(alpha: 0.15),
              child: Icon(
                Iconsax.user,
                size: 20,
                color: badgeColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                user.username,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                user.roleDisplay,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Iconsax.arrow_right_3,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
