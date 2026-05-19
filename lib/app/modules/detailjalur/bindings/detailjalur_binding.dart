import 'package:get/get.dart';

import '../controllers/detailjalur_controller.dart';

class DetailjalurBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailjalurController>(
      () => DetailjalurController(),
    );
  }
}
