import 'package:get/get.dart';

import '../controllers/prediction_history_controller.dart';

class PredictionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PredictionHistoryController>(
      () => PredictionHistoryController(),
    );
  }
}
