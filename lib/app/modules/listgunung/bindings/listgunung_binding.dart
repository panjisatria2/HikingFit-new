import 'package:get/get.dart';

import '../controllers/listgunung_controller.dart';

class ListgunungBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListgunungController>(
      () => ListgunungController(),
    );
  }
}
