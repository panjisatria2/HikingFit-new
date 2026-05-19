import 'package:get/get.dart';

import '../controllers/detailgunung_controller.dart';

class DetailgunungBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailgunungController>(
      () => DetailgunungController(),
    );
  }
}
