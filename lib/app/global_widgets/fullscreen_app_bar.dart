import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// A reusable AppBar for fullscreen (no-bottom-nav) routes.
///
/// - When [onLogout] is provided → admin style: arrow-left icon + logout action.
/// - When [onLogout] is null    → user style: "Kembali" TextButton.
///
/// Both variants share the same green background and zero elevation.
class FullscreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FullscreenAppBar({
    super.key,
    this.onLogout,
    this.onBack,
  });

  /// Provide this for admin-style views (shows logout icon on the right).
  final VoidCallback? onLogout;

  /// Override the back action. Defaults to [Get.back].
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final VoidCallback backAction = onBack ?? () => Get.back();

    if (onLogout != null) {
      // ── Admin style ────────────────────────────────────────────────────────
      return AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: backAction,
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.logout, color: Colors.white),
            onPressed: onLogout,
            tooltip: 'Logout',
          ),
        ],
      );
    }

    // ── User style ────────────────────────────────────────────────────────────
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 110,
      leading: TextButton.icon(
        onPressed: backAction,
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
          size: 16,
        ),
        label: Text(
          'Kembali',
          style: AppTextStyles.appSubtitle(context)
              .copyWith(fontWeight: FontWeight.w500),
        ),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
      ),
      actions: const [SizedBox(width: 8)],
    );
  }
}
