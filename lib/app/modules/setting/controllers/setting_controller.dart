  import 'dart:convert';
  import 'package:get/get.dart';
  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import '../../../utils/api_service.dart'; // Import Kurir Cerdas
  
  class SettingController extends GetxController {
    final RxString fullName = 'Pendaki'.obs;
    final RxString email = ''.obs;
    final RxString profileImageUrl = ''.obs;
    final RxDouble bmiValue = 0.0.obs;
    final RxString bmiStatus = 'Memuat...'.obs;
  
    final RxBool isLoggedIn = false.obs;
    final RxInt weight = 0.obs;
    final RxInt height = 0.obs;
    final RxInt age = 0.obs;
    final RxString gender = ''.obs;
  
    final RxBool isLoading = true.obs;
  
    // Secure storage disisakan HANYA untuk fitur Logout (hapus memori)
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true)
    );
  
    @override
    void onInit() {
      super.onInit();
      checkLoginStatus();
    }
  
    void checkLoginStatus() {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        isLoggedIn.value = true;
        loadProfileData();
      } else {
        isLoggedIn.value = false;
        isLoading.value = false;
        bmiStatus.value = 'Guest Mode';
      }
    }
  
    // =========================================================
    // MENGGUNAKAN API SERVICE
    // =========================================================
    Future<void> loadProfileData() async {
      try {
        isLoading.value = true;
  
        if (isLoggedIn.value) {
          // Cukup panggil ApiService
          final response = await ApiService.get('/api/auth/profile');
  
          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
              final data = jsonResponse['data'];
  
              fullName.value = data['fullName'] ?? 'Pendaki';
              email.value = data['email'] ?? '';
              profileImageUrl.value = data['profileImageUrl'] ?? '';
              bmiValue.value = (data['bmi'] ?? 0).toDouble();
              weight.value = data['weight'] ?? 0;
              height.value = data['height'] ?? 0;
              age.value = data['age'] ?? 0;
              gender.value = data['gender'] ?? '';
  
              bmiStatus.value = _calculateBmiStatus(bmiValue.value);
            }
          }
        }
      } catch (e) {
        bmiStatus.value = 'Error jaringan';
      } finally {
        isLoading.value = false;
      }
    }
  
    String _calculateBmiStatus(double bmi) {
      if (bmi == 0) return 'Belum ada data';
      if (bmi < 18.5) return 'Underweight (Kurus)';
      if (bmi >= 18.5 && bmi <= 24.9) return 'Normal (Ideal)';
      if (bmi >= 25 && bmi <= 29.9) return 'Overweight (Gemuk)';
      return 'Obese (Obesitas)';
    }
  
    void showGuestWarning() {
      Get.snackbar('Akses Ditolak', 'Silakan login terlebih dahulu.', backgroundColor: Colors.orange, colorText: Colors.white);
    }
  
    Future<void> handleLogout() async {
      await FirebaseAuth.instance.signOut();
      await secureStorage.delete(key: 'jwt_token');
      Get.offAllNamed('/login');
    }
  }