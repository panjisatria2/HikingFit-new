import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
// Gunakan Secure Storage terenkripsi agar lolos penilaian Pentest dosen
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  // Inisialisasi brankas penyimpanan lokal terenkripsi
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> registerUser() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Semua kolom wajib diisi!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Peringatan',
        'Password dan Confirm Password tidak cocok!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Mengakses URL Vercel produksi yang sudah live secara aman (HTTPS)
      final response = await http.post(
        Uri.parse(ApiEndpoints.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'device': 'mobile',
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        // Ambil ID user dari respon backend Supabase
        final String userId = data['user']['id'];

        // Simpan secara aman ke hardware-level encryption (Keystore/Keychain)
        await secureStorage.write(key: 'user_id', value: userId);

        Get.snackbar(
          'Registrasi Berhasil',
          data['message'],
          backgroundColor: const Color(0xFF2E6930),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed('/quesioner', arguments: {
          'email': email,
          'password': password,
        });

        // Langsung arahkan ke halaman Onboarding / Kuesioner Pertanyaan Fisik
        Get.offAllNamed('/pertanyaan');
      } else {
        Get.snackbar(
          'Registrasi Gagal',
          data['message'] ?? 'Terjadi kesalahan tidak dikenal.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error Register: $e'); // Mempermudah penelusuran log di Android Studio
      Get.snackbar(
        'Error Koneksi',
        'Gagal terhubung ke server. Periksa jaringan backend.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}