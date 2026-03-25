import 'package:get/get.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/user_prediction_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';
import '../models/user_prediction_model.dart';

class UserHistoryController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxList<UserPredictionModel> histories = <UserPredictionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    histories.assignAll(UserPredictionDummy.getHistory());
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
      onConfirm: () {
        _auth.logout();
        Get.offAllNamed(AppRoutes.signIn);
      },
    );
  }
}
