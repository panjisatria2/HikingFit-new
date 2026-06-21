import 'package:get/get.dart';

class ResumelatihanController extends GetxController {
  final RxString exerciseName = "".obs;
  final RxInt totalReps = 0.obs;
  final RxInt accuracy = 0.obs;
  final RxString duration = "00:00".obs;
  final RxDouble calories = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      exerciseName.value = Get.arguments['exercise_name'] ?? "Latihan";
      totalReps.value = Get.arguments['total_reps'] ?? 0;
      accuracy.value = Get.arguments['accuracy'] ?? 0;
      duration.value = Get.arguments['duration'] ?? "00:00";
      calories.value = Get.arguments['calories'] ?? 0.0;
    }
  }

  void kembaliKeBeranda() {
    Get.offAllNamed('/main');
  }
}