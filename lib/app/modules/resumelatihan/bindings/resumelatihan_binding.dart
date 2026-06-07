import 'package:get/get.dart';

import '../controllers/resumelatihan_controller.dart';

class ResumelatihanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResumelatihanController>(
      () => ResumelatihanController(),
    );
  }
}
