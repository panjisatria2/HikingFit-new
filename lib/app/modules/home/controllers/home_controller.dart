import 'dart:convert';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/api_service.dart'; // Import Kurir Cerdas

class HomeController extends GetxController {
  final RxString userName = 'Pendaki'.obs;
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoggedIn = false.obs;

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
  // MENGGUNAKAN API SERVICE (SANGAT RINGKAS)
  // =========================================================
  Future<void> loadProfileData() async {
    try {
      if (isLoggedIn.value) {
        // Cukup panggil 1 baris ini, ApiService yang urus token fresh-nya!
        final response = await ApiService.get('/api/auth/profile');

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