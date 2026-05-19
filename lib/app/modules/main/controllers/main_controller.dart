import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../../listlatihan/views/listlatihan_view.dart';
import '../../progres/views/progres_view.dart';
import '../../setting/views/setting_view.dart';

class MainController extends GetxController {
  // RxInt untuk reaktivitas super ringan
  final RxInt currentIndex = 0.obs;

  // Menggunakan const list agar widget halaman statis tersimpan di level kompilasi
  final List<Widget> pages = const [
    HomeView(),
    ListlatihanView(),
    ProgresView(),
    SettingView(),
  ];

  // Daftar path gambar asset dibuat const
  final List<String> iconPaths = const [
    'assets/navbar/Home.png',
    'assets/navbar/Training.png',
    'assets/navbar/Progress.png',
    'assets/navbar/Settings.png',
  ];

  final List<String> iconActivePaths = const [
    'assets/navbar/HomeActive.png',
    'assets/navbar/TrainingActive.png',
    'assets/navbar/ProgressActive.png',
    'assets/navbar/SettingsActive.png',
  ];

  @override
  void onInit() {
    super.onInit();
    _checkIncomingArguments();
  }

  @override
  void onReady() {
    super.onReady();
    _checkIncomingArguments();
  }

  void _checkIncomingArguments() {
    if (Get.arguments != null && Get.arguments is int) {
      final int targetIndex = Get.arguments as int;
      // Pastikan index argumennya valid sesuai jumlah tab kita (0-3)
      if (targetIndex >= 0 && targetIndex < pages.length) {
        currentIndex.value = targetIndex;
      }
      // Perbaikan di sini biar gak error setter lagi:
      Get.routing.args = null;
    }
  }

  void changePage(int index) {
    if (currentIndex.value == index) return; // Mencegah rebuild sia-sia jika klik tab yang sama
    currentIndex.value = index;
  }
}