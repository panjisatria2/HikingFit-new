import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/api_service.dart'; // Import Kurir Cerdas

class UbahprofileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final Rx<File?> imageFile = Rx<File?>(null);
  final RxString existingImageUrl = ''.obs;
  final RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      fullNameController.text = args['fullName'] ?? '';
      emailController.text = args['email'] ?? '';
      weightController.text = args['weight']?.toString() ?? '0';
      heightController.text = args['height']?.toString() ?? '0';
      ageController.text = args['age']?.toString() ?? '0';
      selectedGender.value = args['gender'] ?? '';

      String url = args['profileImageUrl'] ?? '';
      if (url.isNotEmpty) {
        existingImageUrl.value = url;
      }
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.onClose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 40);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat gambar: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void removeImage() {
    imageFile.value = null;
    existingImageUrl.value = '';
  }

  void changeGender(String? value) {
    if (value != null) selectedGender.value = value;
  }

  // =========================================================
  // UPDATE KE BACKEND MENGGUNAKAN API SERVICE (PUT)
  // =========================================================
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String finalImageData = existingImageUrl.value;

      if (imageFile.value != null) {
        List<int> imageBytes = await imageFile.value!.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        finalImageData = "data:image/jpeg;base64,$base64Image";
      }

      await user.updateDisplayName(fullNameController.text.trim());

      // Sangat ringkas! Menggunakan ApiService.put
      final response = await ApiService.put('/api/auth/profile', {
        'fullName': fullNameController.text.trim(),
        'height': int.tryParse(heightController.text) ?? 0,
        'weight': int.tryParse(weightController.text) ?? 0,
        'profileImageUrl': finalImageData,
        'age': int.tryParse(ageController.text) ?? 0,
        'gender': selectedGender.value.isNotEmpty ? selectedGender.value : null,
      });

      if (response.statusCode == 200) {
        Get.offAllNamed('/main', arguments: 3);
        Get.snackbar('Sukses', 'Profil berhasil diperbarui!',
            backgroundColor: const Color(0xFF2E6930), colorText: Colors.white);
      } else {
        Get.snackbar('Gagal', 'Server menolak pembaruan data.', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan sistem: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            const Text('Ubah Foto Profil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF2E6930)),
              title: const Text('Kamera'),
              onTap: () { Get.back(); pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF2E6930)),
              title: const Text('Galeri'),
              onTap: () { Get.back(); pickImage(ImageSource.gallery); },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: const Text('Hapus Foto', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () { Get.back(); removeImage(); },
            ),
          ],
        ),
      ),
    );
  }
}