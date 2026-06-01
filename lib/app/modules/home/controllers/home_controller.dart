import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class HomeController extends GetxController {
  final RxString userName = 'Pendaki'.obs;
  final RxString profileImageUrl = ''.obs; // <-- VARIABEL BARU UNTUK FOTO
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
      loadProfileData(); // Ubah nama fungsi agar lebih pas
    } else {
      isLoggedIn.value = false;
    }
  }

  Future<void> loadProfileData() async {
    try {
      String? token = await secureStorage.read(key: 'jwt_token');
      if (token != null) {
        final response = await http.get(
          Uri.parse('${ApiEndpoints.baseUrl}/api/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
            final data = jsonResponse['data'];
            userName.value = data['fullName'] ?? 'Pendaki';
            // TANGKAP LINK FOTO DARI VERCEL
            profileImageUrl.value = data['profileImageUrl'] ?? '';
          }
        }
      }
    } catch (e) {
      // Abaikan jika error
    }
  }
}