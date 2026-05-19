import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class SettingController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString fullName = 'User Guest'.obs;
  final RxInt weight = 0.obs;
  final RxInt height = 0.obs;
  final RxString bmiStatus = '-'.obs;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final token = await secureStorage.read(key: 'jwt_token');

      if (token != null && token.isNotEmpty) {
        isLoggedIn.value = true;

        final response = await http.get(
          Uri.parse(ApiEndpoints.profile),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            final profile = data['data'];
            fullName.value = profile['fullName'] ?? 'Pendaki Fit';
            weight.value = profile['weight'] ?? 0;
            height.value = profile['height'] ?? 0;
            bmiStatus.value = profile['bmiStatus'] ?? 'Belum dihitung';
          }
        } else if (response.statusCode == 401) {
          await handleLogout();
        }
      } else {
        isLoggedIn.value = false;
        resetToGuest();
      }
    } catch (e) {
      debugPrint('Error Loading Setting Profile: $e');
      isLoggedIn.value = false;
      resetToGuest();
    }
  }

  void resetToGuest() {
    fullName.value = 'User Guest';
    weight.value = 0;
    height.value = 0;
    bmiStatus.value = '-';
  }

  // POP-UP PERINGATAN REAKTIF JIKA TAMU MENCOBA AKSES MENU INTERN
  void showGuestWarning() {
    Get.defaultDialog(
        title: "Fitur Terkunci",
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        middleText: "Silakan Login atau Register akun terlebih dahulu untuk merubah setelan profile.",
        textConfirm: "Login Sekarang",
        textCancel: "Batal",
        confirmTextColor: Colors.white,
        cancelTextColor: const Color(0xFF4A7C59),
        buttonColor: const Color(0xFF4A7C59),
        onConfirm: () {
          Get.back();
          Get.toNamed('/login');
        }
    );
  }

  Future<void> handleLogout() async {
    await secureStorage.deleteAll();
    isLoggedIn.value = false;
    resetToGuest();
    Get.offAllNamed('/login');
  }
}