import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CamlatihanController extends GetxController {
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;

  // Default 1 biasanya adalah Kamera Depan (Front) agar user bisa melihat dirinya saat latihan
  final RxInt selectedCameraIndex = 1.obs;

  // --- METRICS DATA LATIHAN (SIAP DIHUBUNGKAN KE MODEL AI POSE ESTIMATION) ---
  final RxInt repsCount = 0.obs;
  final RxInt accuracy = 0.obs;
  final RxString duration = "00:00".obs;
  final RxDouble calories = 0.0.obs;
  final RxBool isMuted = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Jalankan inisialisasi kamera langsung saat controller dimuat
    initCamera(selectedCameraIndex.value);
  }

  Future<void> initCamera(int cameraIndex) async {
    try {
      isCameraInitialized.value = false;

      // 1. Ambil daftar hardware kamera yang tersedia di HP user
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        // 2. Konfigurasi kamera terpilih
        // Menggunakan ResolutionPreset.high agar input frame ke model AI nantinya akurat
        cameraController = CameraController(
          cameras[cameraIndex],
          ResolutionPreset.high,
          enableAudio: false, // Diset false karena kita hanya fokus melacak koordinat pose tubuh
        );

        // 3. Nyalakan stream hardware kamera
        await cameraController!.initialize();
        isCameraInitialized.value = true;
      } else {
        _showErrorSnackbar("Kamera tidak ditemukan pada perangkat ini.");
      }
    } catch (e) {
      debugPrint('Error Inisialisasi Kamera: $e');
      _showErrorSnackbar("Gagal mengakses kamera HP. Pastikan izin kamera sudah diberikan di pengaturan HP.");
    }
  }

  // --- FUNGSI BALIK LENSA (KAMERA DEPAN / BELAKANG) ---
  Future<void> toggleCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.length < 2) {
        Get.snackbar(
          'Info',
          'Perangkat Anda hanya memiliki satu kamera.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Switch index antara 0 (belakang) dan 1 (depan)
      selectedCameraIndex.value = selectedCameraIndex.value == 0 ? 1 : 0;

      // Matikan controller lama secara bersih dari memori RAM
      if (cameraController != null) {
        await cameraController!.dispose();
      }

      // Nyalakan lensa kamera yang baru
      await initCamera(selectedCameraIndex.value);
    } catch (e) {
      debugPrint('Error Toggle Kamera: $e');
    }
  }

  // --- FUNGSI TOGGLE SUARA AUDIO PEMANDU ---
  void toggleMute() {
    isMuted.value = !isMuted.value;
  }

  // --- HELPER SNACKBAR ERROR ---
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error Kamera',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
    );
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}