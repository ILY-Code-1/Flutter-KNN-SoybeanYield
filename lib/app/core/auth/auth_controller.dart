import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
}
