import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QuesionerController extends GetxController {
  final RxInt heightValue = 175.obs;
  final RxInt weightValue = 68.obs;

  final RxInt expIndex = 0.obs;
  final RxInt goalIndex = 0.obs;
  final RxInt mountIndex = 0.obs;

  final RxBool isLoading = false.obs;

  final List<String> expOptions = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> goalOptions = ['Build Stamina', 'Weight Loss', 'Peak Preparation'];
  final List<String> mountOptions = ['Light/Leisure', 'Medium', 'Hard/Extreme'];

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void setExperience(int index) => expIndex.value = index;
  void setGoal(int index) => goalIndex.value = index;
  void setMountain(int index) => mountIndex.value = index;

  Future<void> submitOnboarding() async {
    try {
      isLoading.value = true;

      // 1. Ambil User ID dari brankas secure storage
      final String? userId = await secureStorage.read(key: 'user_id');

      if (userId == null) {
        Get.snackbar(
            'Sesi Kedaluwarsa',
            'Sesi registrasi tidak valid. Silakan daftar ulang.',
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
        Get.offAllNamed('/register');
        return;
      }

      // 2. Tembak ke API Onboarding
      final response = await http.post(
        Uri.parse(ApiEndpoints.onboarding),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'height': heightValue.value,
          'weight': weightValue.value,
          'experienceLevel': expOptions[expIndex.value],
          'fitnessGoals': goalOptions[goalIndex.value],
          'mountainPreference': mountOptions[mountIndex.value],
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // --- PROSES PEMILIHAN JALUR AUTO LOGIN ---
        // Cek apakah ada data email & password yang dititipkan dari halaman Register
        if (Get.arguments != null && Get.arguments['email'] != null) {
          final String email = Get.arguments['email'];
          final String password = Get.arguments['password'];

          // Jalankan login otomatis di background
          await _executeBackgroundLogin(email, password);
        } else {
          // Antisipasi jika user masuk ke kuesioner lewat jalur lain, tetap kembalikan ke login
          Get.offAllNamed('/login');
        }
      } else {
        Get.snackbar(
          'Gagal Menyimpan',
          data['message'] ?? 'Periksa kembali kesesuaian data Anda.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error Onboarding: $e');
      Get.snackbar(
          'Error Koneksi',
          'Gagal terhubung ke server backend.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white
      );
    } finally {
      isLoading.value = false;
    }
  }

  // FUNGSI BARU: Mengambil Token JWT Diam-diam tanpa sepengetahuan User
  Future<void> _executeBackgroundLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'device': 'mobile',
        }),
      );

      final Map<String, dynamic> loginData = jsonDecode(response.body);

      if (response.statusCode == 200 && loginData['success'] == true) {
        // Ambil token JWT resmi dari backend
        final String token = loginData['session']['access_token'];
        final String role = loginData['role'];

        // Simpan langsung ke brankas penyimpanan lokal HP
        await secureStorage.write(key: 'jwt_token', value: token);
        await secureStorage.write(key: 'user_role', value: role);

        Get.snackbar(
          'Profil Lengkap!',
          'Selamat datang di HikingFit!',
          backgroundColor: const Color(0xFF2E6930),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // LANGSUNG TERBANG KE DASHBOARD UTAMA, TANPA LOGIN ULANG MANUAL!
        Get.offAllNamed('/main');
      } else {
        // Jika gagal auto-login, fallback aman dilempar ke menu login manual
        Get.offAllNamed('/login');
      }
    } catch (e) {
      debugPrint('Error Background Login: $e');
      Get.offAllNamed('/login');
    }
  }
}