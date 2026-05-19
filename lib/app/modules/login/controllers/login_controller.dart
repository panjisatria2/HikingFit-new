import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> loginUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Email dan password tidak boleh kosong!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 1. HIT API LOGIN UTAMA KE SERVER VERCEL
      final response = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'device': 'mobile',
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Ambil data token dan user id sesuai struktur JSON asli Abang
        final String token = data['session']['access_token'];
        final String userId = data['user']['id'];
        final String role = data['role'] ?? 'user';

        // Simpan sesi secara aman (Lolos Pentest Dosen)
        await secureStorage.write(key: 'jwt_token', value: token);
        await secureStorage.write(key: 'user_id', value: userId);
        await secureStorage.write(key: 'user_role', value: role);

        // 2. HIT API KEDUA SECARA OTOMATIS: CEK PROFILE KE DATABASE
        // Kita cek secara real-time apakah user ini sudah punya record di tabel profiles Supabase
        final profileResponse = await http.get(
          Uri.parse(ApiEndpoints.profile),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        bool basicProfileCompleted = false;

        if (profileResponse.statusCode == 200) {
          final Map<String, dynamic> profileData = jsonDecode(profileResponse.body);
          if (profileData['success'] == true && profileData['data'] != null) {
            final int height = profileData['data']['height'] ?? 0;
            final int weight = profileData['data']['weight'] ?? 0;

            // Jika tinggi dan berat badan sudah terisi di database, tandai sukses
            if (height > 0 && weight > 0) {
              basicProfileCompleted = true;
            }
          }
        }

        // 3. ALUR PERPINDAHAN HALAMAN BERDASARKAN HASIL DATA FISIK
        if (basicProfileCompleted) {
          Get.snackbar(
            'Welcome Back',
            'Selamat datang kembali di HikingFit!',
            backgroundColor: const Color(0xFF2E6930),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          Get.offAllNamed('/main'); // Masuk Dashboard
        } else {
          // Jika record profile belum ada atau angkanya masih 0, paksa isi kuesioner
          Get.snackbar(
            'Lengkapi Profil Anda',
            'Akun Anda terdeteksi belum melengkapi data kuesioner fisik pendaki.',
            backgroundColor: Colors.amber,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 4),
          );
          Get.offAllNamed('/quesioner'); // Masuk Kuesioner Onboarding
        }

      } else {
        Get.snackbar(
          'Login Gagal',
          data['message'] ?? 'Email atau password salah.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error Login System: $e');
      Get.snackbar(
        'Error Koneksi',
        'Gagal terhubung ke server backend Vercel atau parsing data gagal.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}