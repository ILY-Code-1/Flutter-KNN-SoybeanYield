import 'package:get/get.dart';

import '../core/auth/auth_middleware.dart';
import '../modules/admin/dashboard/bindings/dashboard_binding.dart';
import '../modules/admin/dashboard/views/dashboard_view.dart';
import '../modules/admin/dataset_management/bindings/dataset_management_binding.dart';
import '../modules/admin/dataset_management/views/dataset_management_view.dart';
import '../modules/admin/dataset_management/views/dataset_manual_view.dart';
import '../modules/admin/dataset_management/views/dataset_upload_view.dart';
import '../modules/admin/prediction_history/bindings/prediction_history_binding.dart';
import '../modules/admin/prediction_history/views/history_view.dart';
import '../modules/admin/prediction_history/views/prediction_detail_view.dart';
import '../modules/admin/user_management/bindings/user_management_binding.dart';
import '../modules/admin/user_management/views/user_detail_view.dart';
import '../modules/admin/user_management/views/user_management_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/user/dashboard/bindings/user_dashboard_binding.dart';
import '../modules/user/dashboard/views/user_dashboard_view.dart';
import '../modules/user/history/bindings/user_history_binding.dart';
import '../modules/user/history/views/user_history_view.dart';
import '../modules/user/prediction/bindings/prediction_binding.dart';
import '../modules/user/prediction/views/input_prediksi_view.dart';
import '../modules/user/prediction/views/prediction_detail_user_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),

    // ── Admin ─────────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminUserManagement,
      page: () => const UserManagementView(),
      binding: UserManagementBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminUserDetail,
      page: () => const UserDetailView(),
      binding: UserManagementBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminDatasetManagement,
      page: () => const DatasetManagementView(),
      binding: DatasetManagementBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminDatasetManual,
      page: () => const DatasetManualView(),
      binding: DatasetManagementBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminDatasetUpload,
      page: () => const DatasetUploadView(),
      binding: DatasetManagementBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminPredictionHistory,
      page: () => const HistoryView(),
      binding: PredictionHistoryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminPredictionDetail,
      page: () => const PredictionDetailView(),
      binding: PredictionHistoryBinding(),
      middlewares: [AuthMiddleware()],
    ),

    // ── User (Petani) ─────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.userDashboard,
      page: () => const UserDashboardView(),
      binding: UserDashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.userInputPrediksi,
      page: () => const InputPrediksiView(),
      binding: PredictionBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.userPredictionDetail,
      page: () => const PredictionDetailUserView(),
      // No binding — data passed entirely via Get.arguments
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.userHistory,
      page: () => const UserHistoryView(),
      binding: UserHistoryBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
