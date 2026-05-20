import 'package:get/get.dart';

import '../controllers/camlatihan_controller.dart';

class CamlatihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CamlatihanController>(
      () => CamlatihanController(),
    );
  }
}
