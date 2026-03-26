import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class AuthController extends GetxService {
  final RxBool isLoggedIn = false.obs;
  final RxString userRole = ''.obs;
  final RxString currentUserId = ''.obs;
  final RxString currentUsername = ''.obs;

  void login({
    required String userId,
    required String username,
    required String role,
  }) {
    currentUserId.value = userId;
    currentUsername.value = username;
    userRole.value = role;
    isLoggedIn.value = true;
  }

  /// Clears local auth state and signs out from Firebase Auth.
  void logout() {
    // Fire-and-forget — UI responds to local state immediately
    FirebaseAuth.instance.signOut();
    currentUserId.value = '';
    currentUsername.value = '';
    userRole.value = '';
    isLoggedIn.value = false;
  }

  /// Logout dengan loading overlay stack penuh.
  /// Tampilkan dialog loading → await Firebase signOut → bersihkan state → navigasi.
  /// Get.offAllNamed akan menghapus seluruh stack route termasuk dialog loading.
  Future<void> logoutWithLoading() async {
    // Tampilkan dialog loading, user tidak bisa dismiss manual
    Get.dialog(
      PopScope(
        // canPop: false mencegah dismiss dengan back button saat loading
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
                // Teks di bawah spinner — ubah sesuai kebutuhan
                Text(
                  'Keluar...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Await Firebase signOut agar sesi benar-benar ditutup sebelum navigasi
    await FirebaseAuth.instance.signOut();

    // Bersihkan state lokal
    currentUserId.value = '';
    currentUsername.value = '';
    userRole.value = '';
    isLoggedIn.value = false;

    // offAllNamed menghapus semua route (termasuk dialog loading) lalu push sign in
    Get.offAllNamed(AppRoutes.signIn);
  }
}
