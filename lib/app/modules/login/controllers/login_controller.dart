import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/api_service.dart'; // Import kurir cerdas kita

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RxBool isLoading = false.obs;

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

      if (userCredential.user != null) {
        // MENGGUNAKAN API SERVICE BARU (Sangat ringkas!)
        final response = await ApiService.get('/api/auth/profile');

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

      // Paksa lupa agar selalu memunculkan pilihan akun
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return; // Batal login
      }

      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // MENGGUNAKAN API SERVICE BARU UNTUK SINKRONISASI
        // Perhatikan betapa pendeknya kode ini sekarang!
        final response = await ApiService.post('/api/auth/google-login', {});

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
          String errorAlasan = 'Kode: ${response.statusCode}';
          try {
            final dataErr = jsonDecode(response.body);
            if (dataErr['message'] != null) errorAlasan = dataErr['message'];
          } catch (_) {}

          Get.snackbar('Ditolak Backend', errorAlasan, backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
        }
      }
    } catch (e) {
      Get.snackbar('Error Sistem', 'Google Sign-In gagal: $e', backgroundColor: Colors.red, colorText: Colors.white, duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }
}