import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../routes/app_routes.dart';

class SignInController extends GetxController {
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final _auth = Get.find<AuthController>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn() async {
    final id = idController.text.trim();
    final password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'ID dan Password tidak boleh kosong',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));

    if (id == 'admin@soy.com' && password == 'admin123') {
      _auth.login(userId: '0', username: 'Admin', role: 'admin');
      Get.offAllNamed(AppRoutes.adminDashboard);
    } else if (id == 'user@soy.com' && password == 'user123') {
      _auth.login(userId: '1', username: 'User', role: 'user');
      Get.snackbar(
        'Info',
        'Dashboard User belum tersedia.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Login Gagal',
        'ID atau Password salah. Coba lagi.',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    idController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
