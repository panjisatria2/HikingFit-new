import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/camlatihan_controller.dart';

class CamlatihanView extends GetView<CamlatihanController> {
  const CamlatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: SafeArea(
        child: Stack(
          children: [
            const _CameraPreviewSection(),
            Column(
              children: const [
                _TopHeaderOverlay(),
                Spacer(),
                _RealtimeMetricsDashboard(),
                _BottomActionControls(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraPreviewSection extends GetView<CamlatihanController> {
  const _CameraPreviewSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isCameraInitialized.value || controller.cameraController == null) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF2E6930)));
      }

      final size = MediaQuery.of(context).size;
      var deviceRatio = size.width / size.height;

      return Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 1 / (controller.cameraController!.value.aspectRatio * deviceRatio),
            child: Center(child: CameraPreview(controller.cameraController!)),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2E6930).withOpacity(0.4), width: 2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Positioned(top: 0, left: 0, child: _buildCornerNode()),
                    Positioned(top: 0, right: 0, child: _buildCornerNode()),
                    Positioned(bottom: 0, left: 0, child: _buildCornerNode()),
                    Positioned(bottom: 0, right: 0, child: _buildCornerNode()),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
                        child: const Text(
                          "Posisikan Seluruh Tubuh Anda di Dalam Frame",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCornerNode() {
    return Container(
      width: 14, height: 14, margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Color(0xFF34C759), shape: BoxShape.circle),
    );
  }
}

class _TopHeaderOverlay extends GetView<CamlatihanController> {
  const _TopHeaderOverlay();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
            child: IconButton(icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20), onPressed: () => Get.back()),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
            child: Obx(() => Text("${controller.currentExercise.value} Tracking", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withOpacity(0.2), borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF34C759).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF34C759), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Text("AI ACTIVE", style: TextStyle(color: Color(0xFF34C759), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RealtimeMetricsDashboard extends GetView<CamlatihanController> {
  const _RealtimeMetricsDashboard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF18181B).withOpacity(0.85),
          borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF27272A)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("REPETISI GERAKAN", style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Obx(() => Text("${controller.repsCount.value}", style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("AKURASI POSTUR", style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF2E6930).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF2E6930).withOpacity(0.4))),
                      child: Obx(() => Text("${controller.accuracy.value}%", style: const TextStyle(color: Color(0xFF34C759), fontWeight: FontWeight.w900, fontSize: 16))),
                    ),
                  ],
                )
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(color: Color(0xFF27272A), height: 1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => _buildSubMetricItem(Icons.timer_rounded, "WAKTU", controller.duration.value)),
                Container(width: 1, height: 24, color: const Color(0xFF27272A)),
                Obx(() => _buildSubMetricItem(Icons.local_fire_department_rounded, "KALORI", "${controller.calories.value.toStringAsFixed(1)} kcal", iconColor: Colors.orange)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubMetricItem(IconData icon, String title, String val, {Color iconColor = const Color(0xFF2E6930)}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF71717A), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            const SizedBox(height: 2),
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}

class _BottomActionControls extends GetView<CamlatihanController> {
  const _BottomActionControls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(Icons.flip_camera_ios_rounded, () => controller.toggleCamera()),
          SizedBox(
            width: 140, height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)), elevation: 0,
              ),
              onPressed: () => controller.simpanHasilLatihan(), // Memanggil fungsi pindah halaman
              child: const Text("Selesai Sesi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          Obx(() => _buildActionButton(
            controller.isMuted.value ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                () => controller.toggleMute(), isActive: !controller.isMuted.value,
          )),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, {bool isActive = true}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF18181B), shape: BoxShape.circle, border: Border.all(color: isActive ? const Color(0xFF27272A) : Colors.redAccent.withOpacity(0.5))),
      child: IconButton(icon: Icon(icon, color: isActive ? Colors.white : Colors.redAccent, size: 20), onPressed: onTap),
    );
  }
}