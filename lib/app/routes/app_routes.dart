class AppRoutes {
  AppRoutes._();

  // ── Shared ────────────────────────────────────────────────────────────────
  static const String signIn = '/sign-in';

  // ── Admin ─────────────────────────────────────────────────────────────────
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUserManagement = '/admin/user-management';
  static const String adminUserDetail = '/admin/user-detail';
  static const String adminDatasetManagement = '/admin/dataset-management';
  static const String adminDatasetManual = '/admin/dataset-manual';
  static const String adminDatasetUpload = '/admin/dataset-upload';
  static const String adminPredictionHistory = '/admin/prediction-history';
  static const String adminPredictionDetail = '/admin/prediction-detail';

  // ── User (Petani) ─────────────────────────────────────────────────────────
  static const String userDashboard = '/user/dashboard';
  static const String userInputPrediksi = '/user/input-prediksi';
  static const String userPredictionDetail = '/user/prediction-detail';
  static const String userHistory = '/user/history';
}
