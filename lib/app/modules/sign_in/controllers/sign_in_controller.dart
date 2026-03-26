import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../services/firestore_user_service.dart';

class SignInController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final _auth = Get.find<AuthController>();
  final _userService = FirestoreUserService();

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> signIn() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Username dan Password tidak boleh kosong');
      return;
    }

    isLoading.value = true;
    try {
      final user = await _userService.login(username, password);

      if (user == null) {
        _showError('Username atau password salah');
        return;
      }

      _auth.login(
        userId: user.id,
        username: user.username,
        role: user.role,
        password: user.password,
      );

      if (user.isAdmin) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.userDashboard);
      }
    } catch (_) {
      _showError('Terjadi kesalahan, silakan coba lagi');
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Login Gagal',
      message,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
