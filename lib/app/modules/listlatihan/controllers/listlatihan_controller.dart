import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListlatihanController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await secureStorage.read(key: 'jwt_token');
    isLoggedIn.value = token != null && token.isNotEmpty;
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