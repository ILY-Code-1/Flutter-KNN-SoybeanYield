import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/constants/app_colors.dart';
import 'app/core/auth/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/firestore_dataset_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _initDataset() async {
  try {
    final service = FirestoreDatasetService();
    final empty = await service.isEmpty();
    if (!empty) return; // Already initialized — skip

    final csvContent =
        await rootBundle.loadString('soybean_yield_dataset.txt');
    await service.initializeFromCsv(csvContent);
  } catch (_) {
    // Non-critical: app works even if init fails (admin can upload manually)
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dataset collection from bundled asset (runs only once)
  await _initDataset();

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
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 220),
    );
  }
}
