import 'package:get/get.dart';

import '../controllers/cekkebugaran_controller.dart';

class CekkebugaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CekkebugaranController>(
      () => CekkebugaranController(),
    );
  }
}
