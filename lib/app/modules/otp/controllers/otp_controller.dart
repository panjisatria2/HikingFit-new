import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();
  final RxBool isLoading = false.obs;

  late String uid;
  late String email;

  // Tambahkan brankas penyimpanan token di sini
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  void onInit() {
    super.onInit();
    uid = Get.arguments['uid'] ?? '';
    email = Get.arguments['email'] ?? '';
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 6) {
      Get.snackbar('Perhatian', 'Kode OTP harus berjumlah 6 angka!',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // 1. Tembak Vercel untuk cocokan OTP
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'otp': otpController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        // 2. Jika OTP Benar, Refresh status Firebase di HP agar tahu email sudah verified
        User? currentUser = FirebaseAuth.instance.currentUser;
        await currentUser?.reload();
        currentUser = FirebaseAuth.instance.currentUser; // Ambil data terbaru

        // 3. Ambil Token JWT dan simpan ke brankas
        String? token = await currentUser?.getIdToken();
        if (token != null) {
          await secureStorage.write(key: 'jwt_token', value: token);

          Get.snackbar(
              'Berhasil',
              'Akun terverifikasi! Mari lengkapi profil Anda.',
              backgroundColor: const Color(0xFF4A7C59),
              colorText: Colors.white
          );

          // 4. LOMPAT LANGSUNG KE QUESIONER! 🔥
          Get.offAllNamed('/quesioner');
        } else {
          Get.offAllNamed('/login'); // Jaga-jaga kalau token gagal diambil
        }

      } else {
        final body = jsonDecode(response.body);
        Get.snackbar('Gagal', body['message'] ?? 'OTP Salah atau Kadaluwarsa',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Periksa koneksi internet: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}