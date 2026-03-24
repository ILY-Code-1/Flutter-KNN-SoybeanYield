import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_colors.dart';
import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/user_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../models/user_model.dart';

class UserManagementController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Detail / edit state
  final detailUsernameController = TextEditingController();
  final detailSelectedRole = 'User'.obs;
  final Rxn<UserModel> selectedUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    users.assignAll(UserDummy.getUsers());
    filteredUsers.assignAll(users);

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterUsers();
    });
  }

  void _filterUsers() {
    if (searchQuery.value.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where(
          (u) => u.username
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()),
        ),
      );
    }
  }

  void openDetail(UserModel user) {
    selectedUser.value = user;
    detailUsernameController.text = user.username;
    detailSelectedRole.value = user.role;
    Get.toNamed(AppRoutes.adminUserDetail);
  }

  void openAdd() {
    selectedUser.value = null;
    detailUsernameController.clear();
    detailSelectedRole.value = 'User';
    Get.toNamed(AppRoutes.adminUserDetail);
  }

  void updateUser() {
    final user = selectedUser.value;
    if (user == null) return;

    final updated = user.copyWith(
      username: detailUsernameController.text.trim(),
      role: detailSelectedRole.value,
    );

    final index = users.indexWhere((u) => u.id == updated.id);
    if (index != -1) {
      users[index] = updated;
      users.refresh();
      _filterUsers();
    }

    Get.snackbar(
      'Berhasil',
      'Data user berhasil diperbarui',
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    Get.back();
  }

  void deleteUser(String id) {
    users.removeWhere((u) => u.id == id);
    _filterUsers();
    Get.snackbar(
      'Berhasil',
      'User berhasil dihapus',
      backgroundColor: AppColors.primaryGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
    Get.back();
  }

  void logout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () {
        _auth.logout();
        Get.offAllNamed(AppRoutes.signIn);
      },
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    detailUsernameController.dispose();
    super.onClose();
  }
}
