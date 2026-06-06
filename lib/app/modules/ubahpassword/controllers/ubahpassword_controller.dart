import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UbahpasswordController extends GetxController {
  // Controller untuk input teks
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Variabel untuk menyembunyikan/menampilkan teks password (ikon mata)
  final RxBool isObscureCurrent = true.obs;
  final RxBool isObscureNew = true.obs;
  final RxBool isObscureConfirm = true.obs;

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // =========================================================
  // FUNGSI GANTI PASSWORD KE FIREBASE AUTH
  // =========================================================
  Future<void> updatePassword() async {
    // 1. Validasi Input Lokal
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Peringatan', 'Semua kolom wajib diisi!', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Password baru dan konfirmasi tidak sama!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPasswordController.text.length < 6) {
      Get.snackbar('Error', 'Password baru minimal 6 karakter!', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) {
        Get.snackbar('Error', 'Sesi pengguna tidak ditemukan.', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // 2. Re-Autentikasi (Syarat wajib dari Firebase sebelum ganti password)
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordController.text,
      );

      // Verifikasi password lama
      await user.reauthenticateWithCredential(credential);

      // 3. Eksekusi Ganti Password Baru
      await user.updatePassword(newPasswordController.text);

      // 4. Sukses, kembali ke menu Setting
      Get.back();
      Get.snackbar(
          'Sukses',
          'Password berhasil diperbarui!',
          backgroundColor: const Color(0xFF2E6930),
          colorText: Colors.white
      );

    } on FirebaseAuthException catch (e) {
      // Tangani error jika password lama salah
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        Get.snackbar('Akses Ditolak', 'Password saat ini (lama) yang Anda masukkan salah!', backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan: ${e.message}', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan sistem: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}