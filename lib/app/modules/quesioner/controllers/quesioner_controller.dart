import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class QuesionerController extends GetxController {
  // Variabel Reaktif untuk Slider (Sesuai dengan nama di UI Abang)
  final RxInt heightController = 165.obs;
  final RxInt weightValue = 60.obs;

  // --- EXPERIENCE LEVEL ---
  final List<String> expOptions = ['Beginner', 'Intermediate', 'Advanced'];
  final RxInt expIndex = 0.obs;
  void setExperience(int index) => expIndex.value = index;

  // --- FITNESS GOALS ---
  final List<String> goalOptions = ['Health & Fitness', 'Weight Loss', 'Endurance Training'];
  final RxInt goalIndex = 0.obs;
  void setGoal(int index) => goalIndex.value = index;

  // --- MOUNTAIN PREFERENCE ---
  final List<String> mountOptions = ['Tropical Forest', 'Rocky Terrain', 'Snowy Peaks'];
  final RxInt mountIndex = 0.obs;
  void setMountain(int index) => mountIndex.value = index;

  // Variabel Loading
  final RxBool isLoading = false.obs;

  // Brankas Penyimpanan Token
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Fungsi Submit yang menembak Express Vercel
  Future<void> submitOnboarding() async {
    try {
      isLoading.value = true;

      // 1. Ambil token Firebase yang disimpan saat Login
      String? token = await secureStorage.read(key: 'jwt_token');

      if (token == null) {
        Get.snackbar('Sesi Habis', 'Silakan login ulang', backgroundColor: Colors.red, colorText: Colors.white);
        Get.offAllNamed('/login');
        return;
      }

      // 2. Ambil nilai String asli dari indeks yang dipilih
      String selectedExp = expOptions[expIndex.value];
      String selectedGoal = goalOptions[goalIndex.value];
      String selectedMount = mountOptions[mountIndex.value];

      // 3. Kirim data kuesioner ke Backend Express Vercel
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/auth/onboarding'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'height': heightController.value,
          'weight': weightValue.value,
          'experienceLevel': selectedExp,
          'fitnessGoals': selectedGoal,
          'mountainPreference': selectedMount,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
            'Profil Lengkap!',
            'Data fisik berhasil disimpan, BMI telah dihitung otomatis.',
            backgroundColor: const Color(0xFF2E6930),
            colorText: Colors.white
        );
        // Selesai! Arahkan ke Home
        Get.offAllNamed('/main');
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar('Gagal Menyimpan', body['message'] ?? 'Terjadi kesalahan pada server.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim data. Cek koneksi Anda: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}