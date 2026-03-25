import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../data/dummy/user_dashboard_dummy.dart';
import '../../../../global_widgets/confirm_dialog.dart';
import '../../../../routes/app_routes.dart';

class UserDashboardController extends GetxController {
  final _auth = Get.find<AuthController>();

  final RxInt totalPrediksi = 0.obs;
  final RxString lastResult = ''.obs;
  final RxString lastPredictionDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    totalPrediksi.value = UserDashboardDummy.totalPrediksi;
    lastResult.value = UserDashboardDummy.prediksiTerakhir;
    lastPredictionDate.value =
        DateFormat('dd MMM yyyy').format(UserDashboardDummy.tanggalTerakhir);
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
