import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class LoginController extends GetxController {
  // Controller untuk inputan Text Field
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Variabel untuk efek loading di UI
  final RxBool isLoading = false.obs;

  // Brankas penyimpanan token terenkripsi
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> loginUser() async {
    // Validasi kosong
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Perhatian', 'Email dan password wajib diisi!',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // 1. LOGIN MENGGUNAKAN FIREBASE AUTH
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. AMBIL TOKEN JWT DARI FIREBASE (Ini Kuncinya)
      String? token = await userCredential.user?.getIdToken();

      if (token != null) {
        // Simpan token Firebase ke brankas lokal untuk session
        await secureStorage.write(key: 'jwt_token', value: token);

        // 3. CEK KE BACKEND EXPRESS VERCEL: APAKAH USER SUDAH ISI KUESIONER?
        final response = await http.get(
          Uri.parse(ApiEndpoints.profile),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Kirim token Firebase ke backend
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);

          if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
            final profileData = jsonResponse['data'];

            // Cek kelengkapan data fisik (tinggi & berat)
            bool hasCompletedOnboarding = (profileData['height'] != null && profileData['height'] > 0);

            if (hasCompletedOnboarding) {
              Get.offAllNamed('/main'); // Masuk ke aplikasi utama
            } else {
              Get.offAllNamed('/quesioner'); // Wajib isi kuesioner dulu
            }
          } else {
            // Default kalau data belum ada
            Get.offAllNamed('/quesioner');
          }
        } else {
          // Jika backend Firestore (Vercel) bilang data user belum ada / eror 404
          Get.offAllNamed('/quesioner');
        }
      } else {
        Get.snackbar('Error', 'Gagal mendapatkan token autentikasi.', backgroundColor: Colors.red, colorText: Colors.white);
      }

    } on FirebaseAuthException catch (e) {
      // Tangkap error spesifik bawaan Firebase
      String message = 'Email atau password salah!';
      if (e.code == 'user-not-found') {
        message = 'Akun dengan email ini tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      } else if (e.code == 'invalid-credential') {
        message = 'Kredensial login tidak valid.';
      }
      Get.snackbar('Gagal Login', message, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Koneksi', 'Pastikan internet Anda stabil: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}