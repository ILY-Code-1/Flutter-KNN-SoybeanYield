import 'package:get/get.dart';

import '../controllers/dataset_management_controller.dart';

class DatasetManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatasetManagementController>(
      () => DatasetManagementController(),
    );
  }
}
