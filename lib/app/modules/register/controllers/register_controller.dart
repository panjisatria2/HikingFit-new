import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../../utils/api_endpoints.dart';

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> registerUser() async {
    if (fullNameController.text.isEmpty || emailController.text.isEmpty ||
        passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar('Perhatian', 'Semua kolom wajib diisi!', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Password dan Konfirmasi tidak cocok!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // 1. Buat akun di Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Set Nama di lokal Firebase
      await userCredential.user?.updateDisplayName(fullNameController.text.trim());

      final String uid = userCredential.user!.uid;
      final String email = emailController.text.trim();
      final String fullName = fullNameController.text.trim();

      // 3. Tembak Vercel untuk kirim OTP sekaligus simpan nama
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'uid': uid,
          'email': email,
          'fullName': fullName, // Dikirim ke Vercel
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'OTP terkirim!', backgroundColor: const Color(0xFF4A7C59), colorText: Colors.white);
        Get.toNamed('/otp', arguments: {'uid': uid, 'email': email});
      } else {
        final body = jsonDecode(response.body);
        Get.snackbar('Gagal', body['message'] ?? 'Gagal', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Gagal Register', e.message ?? 'Error Firebase', backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}