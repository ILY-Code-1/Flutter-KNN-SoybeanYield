import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../global_widgets/admin_bottom_nav.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../global_widgets/primary_button.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username
              _fieldLabel('Username'),
              const SizedBox(height: 8),
              _textField(
                controller: controller.detailUsernameController,
                hint: 'Masukan username',
              ),
              const SizedBox(height: 20),

              // Role
              _fieldLabel('Role'),
              const SizedBox(height: 8),
              Obx(
                () => _dropdownField(
                  value: controller.detailSelectedRole.value,
                  items: const ['Admin', 'User'],
                  onChanged: (val) {
                    if (val != null) {
                      controller.detailSelectedRole.value = val;
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Created At
              _fieldLabel('Created At'),
              const SizedBox(height: 8),
              Obx(
                () => _textField(
                  controller: TextEditingController(
                    text: controller.selectedUser.value != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(controller.selectedUser.value!.createdAt)
                        : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  ),
                  hint: '',
                  enabled: false,
                ),
              ),
              const SizedBox(height: 32),

              // Buttons
              Obx(() {
                final isEdit = controller.selectedUser.value != null;
                if (isEdit) {
                  return Column(
                    children: [
                      PrimaryButton(
                        text: 'UPDATE',
                        backgroundColor: AppColors.accentTeal,
                        onPressed: () {
                          ConfirmDialog.show(
                            title: 'Simpan Perubahan',
                            message: 'Apakah data sudah benar?',
                            confirmText: 'Simpan',
                            isDanger: false,
                            onConfirm: controller.updateUser,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: 'DELETE',
                        backgroundColor: AppColors.deleteRed,
                        onPressed: () {
                          final id = controller.selectedUser.value!.id;
                          ConfirmDialog.show(
                            title: 'Hapus User',
                            message: 'Tindakan ini tidak bisa dibatalkan.',
                            confirmText: 'Hapus',
                            isDanger: true,
                            onConfirm: () => controller.deleteUser(id),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return PrimaryButton(
                    text: 'TAMBAH USER',
                    onPressed: () {
                      Get.snackbar(
                        'Info',
                        'Fitur tambah user akan segera tersedia',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                      );
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryGreen,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Detail',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Kelola Pengguna dengan Mudah',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.85),
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
        fillColor: enabled ? AppColors.inputBackground : const Color(0xFFF5F5F5),
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
                  child: Text(r, style: GoogleFonts.poppins(fontSize: 14)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
