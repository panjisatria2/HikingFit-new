import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// Gunakan Secure Storage yang sama dengan halaman Login
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class HomeController extends GetxController {
  final RxString userName = 'Guest'.obs;
  final RxBool isLoggedIn = false.obs;

  // Inisialisasi penyimpanan terenkripsi
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // BACA TOKEN DARI SECURE STORAGE, BUKAN SHARED PREFERENCES
    final token = await secureStorage.read(key: 'jwt_token');

    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      await fetchUserProfile(token);
    } else {
      isLoggedIn.value = false;
      userName.value = 'Guest';
    }
  }

  Future<void> fetchUserProfile(String token) async {
    try {
      final response = await http.get(
        // Rute ini otomatis membongkar ID dari token di backend Vercel kita
        Uri.parse(ApiEndpoints.profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          String fullName = data['data']['fullName'] ?? 'Pendaki';
          userName.value = fullName.split(' ')[0]; // Ambil nama depan saja
        }
      } else if (response.statusCode == 401) {
        // TOKEN KEDALUWARSA ATAU TIDAK VALID: Hapus data keamanan lokal
        await secureStorage.deleteAll();
        isLoggedIn.value = false;
        userName.value = 'Guest';
        debugPrint('Token expired, sesi dikembalikan ke Guest.');
      }
    } catch (e) {
      debugPrint('Gagal mengambil data profil: $e');
    }
  }

  // Fungsi tambahan untuk Logout dari Web/Aplikasi nanti
  Future<void> logout() async {
    await secureStorage.deleteAll();
    isLoggedIn.value = false;
    userName.value = 'Guest';
    Get.offAllNamed('/login'); // Lempar kembali ke login
  }
}