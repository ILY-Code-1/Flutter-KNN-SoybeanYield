import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../../global_widgets/fullscreen_app_bar.dart';
import '../controllers/user_management_controller.dart';

class UserDetailView extends GetView<UserManagementController> {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FullscreenAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Green header ─────────────────────────────────────────────────
            _buildHeader(context),

            // ── Content section ───────────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
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
                        // ── Username ─────────────────────────────────────────
                        _fieldLabel(context, 'Username'),
                        const SizedBox(height: 8),
                        _textField(
                          context: context,
                          controller: controller.usernameController,
                          hint: 'Masukan username',
                        ),
                        const SizedBox(height: 20),

                        // ── Password (ADD mode only) ──────────────────────────
                        if (!isEdit) ...[
                          _fieldLabel(context, 'Password'),
                          const SizedBox(height: 8),
                          Obx(
                            () => TextField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              style: AppTextStyles.inputFieldText(context),
                              decoration: InputDecoration(
                                hintText: 'Min. 6 karakter',
                                hintStyle:
                                    AppTextStyles.inputFieldHint(context),
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
                                  onPressed:
                                      controller.togglePasswordVisibility,
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

                        // ── Role ─────────────────────────────────────────────
                        _fieldLabel(context, 'Role'),
                        const SizedBox(height: 8),
                        Obx(
                          () => _dropdownField(
                            context: context,
                            value: controller.selectedRole.value,
                            items: const ['admin', 'user'],
                            displayLabels: const {
                              'admin': 'Admin',
                              'user': 'User'
                            },
                            onChanged: (val) {
                              if (val != null)
                                controller.selectedRole.value = val;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ── Created At (EDIT mode only) ───────────────────────
                        if (isEdit) ...[
                          _fieldLabel(context, 'Created At'),
                          const SizedBox(height: 8),
                          _textField(
                            context: context,
                            controller: TextEditingController(
                              text: DateFormat('yyyy-MM-dd').format(
                                  controller.selectedUser.value!.createdAt),
                            ),
                            hint: '',
                            enabled: false,
                          ),
                          const SizedBox(height: 32),
                        ] else
                          const SizedBox(height: 12),

                        // ── Buttons ──────────────────────────────────────────
                        if (isEdit) ...[
                          Obx(
                            () => _actionButton(
                              context: context,
                              label: 'UPDATE',
                              color: AppColors.accentTeal,
                              isLoading: controller.isSaving.value,
                              onPressed: () => controller.confirmUpdate(
                                  controller.selectedUser.value!.id),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => _actionButton(
                              context: context,
                              label: 'DELETE',
                              color: AppColors.deleteRed,
                              isLoading: controller.isSaving.value,
                              onPressed: () => controller.confirmDelete(
                                  controller.selectedUser.value!.id),
                            ),
                          ),
                        ] else ...[
                          Obx(
                            () => _actionButton(
                              context: context,
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
            ),
          ],
        ),
      ),
    );
  }

  // ── Green header ────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final isEdit = controller.selectedUser.value != null;
      return Container(
        width: double.infinity,
        color: AppColors.primaryGreen,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEdit ? 'User Detail' : 'Tambah User',
              style: AppTextStyles.appTitle(context),
            ),
            const SizedBox(height: 4),
            Text(
              isEdit
                  ? 'Kelola pengguna dengan mudah.'
                  : 'Buat akun pengguna baru.',
              style: AppTextStyles.appSubtitle(context),
            ),
          ],
        ),
      );
    });
  }

  // ── Reusable field widgets ──────────────────────────────────────────────────

  Widget _fieldLabel(BuildContext context, String label) {
    return Text(label, style: AppTextStyles.detailLabel(context));
  }

  Widget _textField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: AppTextStyles.inputFieldText(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.inputFieldHint(context),
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
    required BuildContext context,
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
          style: AppTextStyles.inputFieldText(context),
          dropdownColor: AppColors.white,
          items: items
              .map(
                (r) => DropdownMenuItem(
                  value: r,
                  child: Text(
                    displayLabels[r] ?? r,
                    style: AppTextStyles.inputFieldText(context),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
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
                style: AppTextStyles.buttonText(context)
                    .copyWith(letterSpacing: 0.5),
              ),
      ),
    );
  }
}
