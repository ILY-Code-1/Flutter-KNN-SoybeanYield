import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/constants/app_colors.dart';
import 'app/core/auth/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);
  runApp(const SoyBeanYieldApp());
}

class SoyBeanYieldApp extends StatelessWidget {
  const SoyBeanYieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SoyBeanYield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.signIn,
      getPages: AppPages.routes,
    );
  }
}
