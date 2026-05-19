import 'package:get/get.dart';

import '../controllers/quesioner_controller.dart';

class QuesionerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuesionerController>(
      () => QuesionerController(),
    );
  }
}
