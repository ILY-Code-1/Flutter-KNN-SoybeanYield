import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/admin_bottom_nav.dart';
import '../controllers/user_management_controller.dart';

class UserDetailView extends GetView<UserManagementController> {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
          child: Obx(() {
            final isEdit = controller.selectedUser.value != null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Username ────────────────────────────────────────────────
                _fieldLabel('Username'),
                const SizedBox(height: 8),
                _textField(
                  controller: controller.usernameController,
                  hint: 'Masukan username',
                ),
                const SizedBox(height: 20),

                // ── Password (ADD mode only) ─────────────────────────────────
                if (!isEdit) ...[
                  _fieldLabel('Password'),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Min. 6 karakter',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.inputBackground,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Role ────────────────────────────────────────────────────
                _fieldLabel('Role'),
                const SizedBox(height: 8),
                Obx(
                  () => _dropdownField(
                    value: controller.selectedRole.value,
                    items: const ['admin', 'user'],
                    displayLabels: const {'admin': 'Admin', 'user': 'User'},
                    onChanged: (val) {
                      if (val != null) controller.selectedRole.value = val;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ── Created At (EDIT mode only) ──────────────────────────────
                if (isEdit) ...[
                  _fieldLabel('Created At'),
                  const SizedBox(height: 8),
                  _textField(
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd')
                          .format(controller.selectedUser.value!.createdAt),
                    ),
                    hint: '',
                    enabled: false,
                  ),
                  const SizedBox(height: 32),
                ] else
                  const SizedBox(height: 12),

                // ── Buttons ─────────────────────────────────────────────────
                if (isEdit) ...[
                  // UPDATE
                  Obx(
                    () => _actionButton(
                      label: 'UPDATE',
                      color: AppColors.accentTeal,
                      isLoading: controller.isSaving.value,
                      onPressed: () => controller
                          .confirmUpdate(controller.selectedUser.value!.id),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // DELETE
                  Obx(
                    () => _actionButton(
                      label: 'DELETE',
                      color: AppColors.deleteRed,
                      isLoading: controller.isSaving.value,
                      onPressed: () => controller
                          .confirmDelete(controller.selectedUser.value!.id),
                    ),
                  ),
                ] else ...[
                  // TAMBAH USER
                  Obx(
                    () => _actionButton(
                      label: 'TAMBAH USER',
                      color: AppColors.primaryGreen,
                      isLoading: controller.isSaving.value,
                      onPressed: controller.addUser,
                    ),
                  ),
                ],
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        final isEdit = controller.selectedUser.value != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'User Detail' : 'Tambah User',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              isEdit
                  ? 'Kelola Pengguna dengan Mudah'
                  : 'Buat akun pengguna baru',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        );
      }),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.logout, color: Colors.white),
          onPressed: controller.logout,
          tooltip: 'Logout',
        ),
      ],
    );
  }

  // ── Reusable field widgets ─────────────────────────────────────────────────

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor:
            enabled ? AppColors.inputBackground : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required Map<String, String> displayLabels,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          dropdownColor: AppColors.white,
          items: items
              .map(
                (r) => DropdownMenuItem(
                  value: r,
                  child: Text(
                    displayLabels[r] ?? r,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// Full-width action button with integrated loading spinner.
  Widget _actionButton({
    required String label,
    required Color color,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color.withValues(alpha: 0.6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
