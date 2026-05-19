import 'package:get/get.dart';

import '../controllers/listlatihan_controller.dart';

class ListlatihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListlatihanController>(
      () => ListlatihanController(),
    );
  }
}
