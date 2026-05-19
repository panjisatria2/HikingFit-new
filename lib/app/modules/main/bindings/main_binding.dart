import 'package:get/get.dart';
import 'package:hikingfit/app/modules/listlatihan/controllers/listlatihan_controller.dart';
import 'package:hikingfit/app/modules/progres/controllers/progres_controller.dart';
import 'package:hikingfit/app/modules/setting/controllers/setting_controller.dart';
import '../controllers/main_controller.dart';
// WAJIB IMPORT CONTROLLER DARI TAB YANG ADA DI BOTTOM NAVIGATION
import '../../home/controllers/home_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
          () => MainController(),
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
    Get.lazyPut<SettingController>(
          () => SettingController(),
    );
    Get.lazyPut<ListlatihanController>(
          () => ListlatihanController(),
    );
    Get.lazyPut<ProgresController>(
          () => ProgresController(),
    );
  }
}