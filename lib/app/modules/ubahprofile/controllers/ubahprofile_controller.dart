import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../utils/api_endpoints.dart';

class UbahprofileController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  final Rx<File?> imageFile = Rx<File?>(null);
  final RxString existingImageUrl = ''.obs;
  final RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      fullNameController.text = args['fullName'] ?? '';
      emailController.text = args['email'] ?? '';
      weightController.text = args['weight']?.toString() ?? '0';
      heightController.text = args['height']?.toString() ?? '0';
      existingImageUrl.value = args['profileImageUrl'] ?? '';
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) imageFile.value = File(pickedFile.path);
  }

  void removeImage() {
    imageFile.value = null;
    existingImageUrl.value = '';
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? imageUrl = existingImageUrl.value;

      if (imageFile.value != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${user.uid}.jpg');
        final uploadTask = await storageRef.putFile(imageFile.value!);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      await user.updateDisplayName(fullNameController.text.trim());
      if (imageUrl.isNotEmpty) await user.updatePhotoURL(imageUrl);

      String? token = await secureStorage.read(key: 'jwt_token');
      final response = await http.put(
        Uri.parse('${ApiEndpoints.baseUrl}/api/auth/profile'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({
          'fullName': fullNameController.text.trim(),
          'height': int.tryParse(heightController.text) ?? 0,
          'weight': int.tryParse(weightController.text) ?? 0,
          'profileImageUrl': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        Get.offAllNamed('/main', arguments: 3);
        Get.snackbar('Sukses', 'Profil berhasil diperbarui!', backgroundColor: const Color(0xFF2E6930), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Kamera'), onTap: () { Get.back(); pickImage(ImageSource.camera); }),
          ListTile(leading: const Icon(Icons.photo_library), title: const Text('Galeri'), onTap: () { Get.back(); pickImage(ImageSource.gallery); }),
          ListTile(leading: const Icon(Icons.delete, color: Colors.red), title: const Text('Hapus Foto', style: TextStyle(color: Colors.red)), onTap: () { Get.back(); removeImage(); }),
        ]),
      ),
    );
  }
}