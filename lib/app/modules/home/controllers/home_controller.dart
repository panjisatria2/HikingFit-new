import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
// secure_storage sudah tidak terlalu dibutuhkan untuk token, tapi dibiarkan jika ada keperluan lain
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class HomeController extends GetxController {
  final RxString userName = 'Pendaki'.obs;
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoggedIn = false.obs;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
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
    }
  }

  // =========================================================
  // UPDATE: AMBIL TOKEN FRESH DARI FIREBASE
  // =========================================================
  Future<void> loadProfileData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Baris sakti: Firebase akan otomatis memberikan token baru jika token lama sudah expired (lewat 1 jam)
        String? token = await user.getIdToken();

        final response = await http.get(
          Uri.parse('${ApiEndpoints.baseUrl}/api/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Kirim token fresh ke Vercel
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
            final data = jsonResponse['data'];
            userName.value = data['fullName'] ?? 'Pendaki';
            profileImageUrl.value = data['profileImageUrl'] ?? '';
          }
        }
      }
    } catch (e) {
      // Abaikan jika error agar tidak mengganggu UI
    }
  }
}