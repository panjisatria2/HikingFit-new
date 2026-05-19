import 'package:get/get.dart';

import '../controllers/ubahpassword_controller.dart';

class UbahpasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UbahpasswordController>(
      () => UbahpasswordController(),
    );
  }
}
