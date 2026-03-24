import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../services/firebase_auth_service.dart';
import '../../../services/firestore_user_service.dart';

class SignInController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final _auth = Get.find<AuthController>();
  final _authService = FirebaseAuthService();
  final _userService = FirestoreUserService();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Username dan Password tidak boleh kosong');
      return;
    }

    isLoading.value = true;
    try {
      final credential = await _authService.signIn(username, password);
      final uid = credential?.user?.uid;
      if (uid == null) throw Exception('Login gagal, coba lagi');

      final role = await _userService.getUserRole(uid);
      if (role == null) {
        // Firestore doc missing — sign out and surface the error
        await _authService.signOut();
        throw Exception('Data pengguna tidak ditemukan di sistem');
      }

      _auth.login(userId: uid, username: username, role: role);

      if (role.toLowerCase() == 'admin') {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        // User dashboard not yet implemented
        Get.snackbar(
          'Info',
          'Dashboard User belum tersedia.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        await _authService.signOut();
        _auth.logout();
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Terjadi kesalahan, silakan coba lagi');
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
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
      snackPosition: SnackPosition.BOTTOM,
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
