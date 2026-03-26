import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firestore_user_service.dart';
import '../models/user_model.dart';

class UserManagementController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _userService = FirestoreUserService();

  // ── State ─────────────────────────────────────────────────────────────────

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final Rxn<UserModel> selectedUser = Rxn<UserModel>();

  // ── Form controllers ──────────────────────────────────────────────────────

  final searchController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final RxString selectedRole = 'user'.obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> loadUsers() async {
    isLoading.value = true;
    try {
      final data = await _userService.getUsers();
      users.assignAll(data);
      filteredUsers.assignAll(data);
    } catch (_) {
      _showError('Gagal memuat data pengguna');
    } finally {
      isLoading.value = false;
    }
  }

  void searchUser(String query) {
    if (query.trim().isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where(
          (u) => u.username.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void openDetail(UserModel user) {
    selectedUser.value = user;
    usernameController.text = user.username;
    selectedRole.value = user.role;
    isPasswordVisible.value = false;
    Get.toNamed(AppRoutes.adminUserDetail);
  }

  void openAdd() {
    selectedUser.value = null;
    usernameController.clear();
    passwordController.clear();
    selectedRole.value = 'user';
    isPasswordVisible.value = false;
    Get.toNamed(AppRoutes.adminUserDetail);
  }

  // ── Add User ──────────────────────────────────────────────────────────────

  Future<void> addUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty) {
      _showError('Username tidak boleh kosong');
      return;
    }
    if (password.length < 6) {
      _showError('Password minimal 6 karakter');
      return;
    }

    final exists = await _userService.isUsernameExists(username);
    if (exists) {
      _showError('Username sudah digunakan');
      return;
    }

    isSaving.value = true;
    try {
      final uid = await _userService.createUser(
        username,
        password,
        selectedRole.value,
      );
      if (uid == null) throw Exception('Gagal menyimpan data pengguna');
      await loadUsers();
      _clearForm();
      Get.back();
      _showSuccess('User berhasil ditambahkan');
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSaving.value = false;
    }
  }

  // ── Update User ───────────────────────────────────────────────────────────

  void confirmUpdate(String uid) {
    ConfirmDialog.show(
      title: 'Simpan Perubahan',
      message: 'Apakah data sudah benar?',
      confirmText: 'Simpan',
      onConfirm: () => updateUser(uid),
    );
  }

  Future<void> updateUser(String uid) async {
    final username = usernameController.text.trim();
    if (username.isEmpty) {
      _showError('Username tidak boleh kosong');
      return;
    }

    final exists =
        await _userService.isUsernameExists(username, excludeUid: uid);
    if (exists) {
      _showError('Username sudah digunakan');
      return;
    }

    isSaving.value = true;
    try {
      final success =
          await _userService.updateUser(uid, username, selectedRole.value);
      if (!success) throw Exception('Gagal memperbarui data');

      await loadUsers();
      Get.back();
      _showSuccess('Data user berhasil diperbarui');
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSaving.value = false;
    }
  }

  // ── Delete User ───────────────────────────────────────────────────────────

  void confirmDelete(String uid) {
    ConfirmDialog.show(
      title: 'Hapus User',
      message: 'Tindakan ini tidak bisa dibatalkan.',
      confirmText: 'Hapus',
      isDanger: true,
      onConfirm: () => deleteUser(uid),
    );
  }

  Future<void> deleteUser(String uid) async {
    isSaving.value = true;
    try {
      final success = await _userService.deleteUserDoc(uid);
      if (!success) throw Exception('Gagal menghapus data');

      await loadUsers();
      Get.back();
      _showSuccess('User berhasil dihapus');
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      isSaving.value = false;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () => _auth.logoutWithLoading(),
    );
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _clearForm() {
    usernameController.clear();
    passwordController.clear();
    selectedRole.value = 'user';
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
