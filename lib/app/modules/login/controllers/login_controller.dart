import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RxBool isLoading = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // =========================================================
  // 1. FUNGSI LOGIN MANUAL (EMAIL & PASSWORD)
  // =========================================================
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Perhatian', 'Email dan password wajib diisi!', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String? token = await userCredential.user?.getIdToken();

      if (token != null) {
        await secureStorage.write(key: 'jwt_token', value: token);

        final response = await http.get(
          Uri.parse('${ApiEndpoints.baseUrl}/api/auth/profile'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
            final profileData = jsonResponse['data'];
            bool hasCompletedOnboarding = (profileData['height'] != null && profileData['height'] > 0);

            if (hasCompletedOnboarding) {
              Get.offAllNamed('/main');
            } else {
              Get.offAllNamed('/quesioner');
            }
          } else {
            Get.offAllNamed('/quesioner');
          }
        } else {
          Get.offAllNamed('/quesioner');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Email atau password salah!';
      if (e.code == 'user-not-found') message = 'Akun dengan email ini tidak ditemukan.';
      else if (e.code == 'wrong-password') message = 'Password salah.';
      else if (e.code == 'invalid-credential') message = 'Kredensial login tidak valid.';
      Get.snackbar('Gagal Login', message, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Koneksi', 'Pastikan internet stabil: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // 2. FUNGSI LOGIN OTOMATIS (GOOGLE SIGN-IN)
  // =========================================================
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      // 1. JURUS PAKSA LUPA: Putuskan sesi lama agar selalu milih akun Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      await _googleSignIn.signOut();

      // 2. Munculkan dialog pilihan akun
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return; // Dibatalkan oleh user
      }

      // 3. Masukkan ke Firebase
      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String? token = await user.getIdToken();
        await secureStorage.write(key: 'jwt_token', value: token);

        // 4. Sinkronisasi ke Backend Express
        final String urlTarget = '${ApiEndpoints.baseUrl}/api/auth/google-login';

        final response = await http.post(
          Uri.parse(urlTarget),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token' // Wajib sama persis formatnya dengan backend
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['isNewUser'] == true) {
            Get.snackbar('Selamat Datang!', 'Akun berhasil dibuat via Google.', backgroundColor: const Color(0xFF2E6930), colorText: Colors.white);
            Get.offAllNamed('/quesioner');
          } else {
            Get.snackbar('Sukses', 'Berhasil masuk.', backgroundColor: const Color(0xFF2E6930), colorText: Colors.white);
            Get.offAllNamed('/main');
          }
        } else {
          // --- DETEKTIF ERROR BACKEND ---
          // Membaca pesan asli dari backend (dari file authRoutes.js Abang)
          String errorAlasan = 'Kode: ${response.statusCode}';
          try {
            final dataErr = jsonDecode(response.body);
            if (dataErr['message'] != null) {
              errorAlasan = dataErr['message'];
            }
          } catch (_) {}

          Get.snackbar(
            'Ditolak Backend (${response.statusCode})',
            errorAlasan,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 5), // Ditahan 5 detik agar gampang dibaca
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error Sistem', 'Google Sign-In gagal: $e', backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }
}