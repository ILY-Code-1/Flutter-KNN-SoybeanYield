import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class AuthController extends GetxService {
  final RxBool isLoggedIn = false.obs;
  final RxString userRole = ''.obs;
  final RxString currentUserId = ''.obs;
  final RxString currentUsername = ''.obs;
  final RxString currentPassword = ''.obs;

  void login({
    required String userId,
    required String username,
    required String role,
    required String password,
  }) {
    currentUserId.value = userId;
    currentUsername.value = username;
    currentPassword.value = password;
    userRole.value = role;
    isLoggedIn.value = true;
  }

  void logout() {
    currentUserId.value = '';
    currentUsername.value = '';
    userRole.value = '';
    isLoggedIn.value = false;
  }

  Future<void> logoutWithLoading() async {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(strokeWidth: 3),
                SizedBox(height: 16),
                Text(
                  'Keluar...',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(milliseconds: 500));

    currentUserId.value = '';
    currentUsername.value = '';
    userRole.value = '';
    isLoggedIn.value = false;

    Get.offAllNamed(AppRoutes.signIn);
  }
}
