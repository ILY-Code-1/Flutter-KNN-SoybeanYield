import 'package:get/get.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/firestore_prediction_service.dart';
import '../models/user_prediction_model.dart';

class UserHistoryController extends GetxController {
  final _auth = Get.find<AuthController>();
  final _predictionService = FirestorePredictionService();

  final RxList<UserPredictionModel> histories = <UserPredictionModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    final result = await _predictionService
        .getUserPredictions(_auth.currentUserId.value);
    histories.assignAll(result);
    isLoading.value = false;
  }

  void selectHistory(UserPredictionModel prediction) {
    Get.toNamed(AppRoutes.userPredictionDetail, arguments: prediction);
  }

  void confirmLogout() {
    ConfirmDialog.show(
      title: 'Logout',
      message: 'Apakah kamu yakin ingin keluar?',
      confirmText: 'Logout',
      isDanger: true,
      onConfirm: () => _auth.logoutWithLoading(),
    );
  }
}
