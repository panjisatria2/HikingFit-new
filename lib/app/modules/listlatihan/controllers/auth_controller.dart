import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  Future<void> checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? token = await secureStorage.read(key: 'jwt_token');
    isLoggedIn.value = (user != null || (token != null && token.isNotEmpty));
  }
}