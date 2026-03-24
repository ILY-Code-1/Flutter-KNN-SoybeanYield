import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constants/app_colors.dart';
import '../../../global_widgets/primary_button.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 52),
                // Logo
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(Icons.eco, size: 44, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'HALO!!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Selamat Datang di SoyBeanYield !',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Masukan Username dan Password untuk Masuk',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Username Field
                      _buildFieldLabel('Username'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.usernameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: _inputDecoration(
                          hint: 'Masukan Username',
                          prefixIcon: const Icon(
                            Iconsax.user,
                            color: AppColors.primaryGreen,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      _buildFieldLabel('Password'),
                      const SizedBox(height: 8),
                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => controller.signIn(),
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: _inputDecoration(
                            hint: 'Masukan Password',
                            prefixIcon: const Icon(
                              Iconsax.lock,
                              color: AppColors.primaryGreen,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Iconsax.eye
                                    : Iconsax.eye_slash,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => PrimaryButton(
                          text: 'SIGN IN',
                          onPressed: controller.signIn,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 13,
        color: AppColors.textSecondary,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }
}
