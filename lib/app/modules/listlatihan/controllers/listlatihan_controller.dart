import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class ListlatihanController extends GetxController {
  final AuthController auth = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    auth.checkAuth();
  }

  void mulaiLatihan(String namaOlahraga) {
    if (auth.isLoggedIn.value) {
      Get.toNamed('/camlatihan', arguments: {'exercise_name': namaOlahraga});
    } else {
      showGuestWarning();
    }
  }

  void showGuestWarning() {
    Get.defaultDialog(
      title: "Fitur Terkunci",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Silakan Login atau Register untuk mengakses program gerakan latihan fisik.",
      textConfirm: "Login Sekarang",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      cancelTextColor: const Color(0xFF2E6930),
      buttonColor: const Color(0xFF2E6930),
      onConfirm: () {
        Get.back();
        Get.toNamed('/login');
      },
    );
  }
}