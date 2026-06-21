import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
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

      // PERBAIKAN KAMERA AGAR TIDAK MEMANJANG (STRETCHED)
      // Mengunci proporsi sesuai dengan rasio asli kamera HP Android
      var cameraRatio = controller.cameraController!.value.aspectRatio;
      if (cameraRatio > 1) {
        // Balikkan rasio menjadi portrait
        cameraRatio = 1 / cameraRatio;
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black, // Latar belakang jika kamera tidak memenuhi seluruh layar
            child: Center(
              child: AspectRatio(
                aspectRatio: cameraRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(controller.cameraController!),
                    Obx(() {
                      if (controller.currentPose.value != null) {
                        return CustomPaint(
                          painter: PosePainter(
                            controller.currentPose.value!,
                            controller.cameraImageSize,
                            controller.isFrontCamera,
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
          // Bingkai Petunjuk
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF2E6930).withOpacity(0.4), width: 2), borderRadius: BorderRadius.circular(24)),
                child: Stack(
                  children: [
                    Positioned(top: 0, left: 0, child: _buildCornerNode()), Positioned(top: 0, right: 0, child: _buildCornerNode()),
                    Positioned(bottom: 0, left: 0, child: _buildCornerNode()), Positioned(bottom: 0, right: 0, child: _buildCornerNode()),
                    Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)), child: const Text("Posisikan Seluruh Tubuh Anda di Dalam Frame", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500))))
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
  Widget _buildCornerNode() => Container(width: 14, height: 14, margin: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFF34C759), shape: BoxShape.circle));
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
          Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle), child: IconButton(icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20), onPressed: () => Get.back())),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)), child: Obx(() => Text("${controller.currentExercise.value} Tracking", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF34C759).withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF34C759).withOpacity(0.5))),
            child: Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF34C759), shape: BoxShape.circle)), const SizedBox(width: 6), const Text("AI ACTIVE", style: TextStyle(color: Color(0xFF34C759), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5))]),
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
        width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: const Color(0xFF18181B).withOpacity(0.85), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF27272A))),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("REPETISI GERAKAN", style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)), const SizedBox(height: 4), Obx(() => Text("${controller.repsCount.value}", style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1)))]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text("AKURASI POSTUR", style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)), const SizedBox(height: 6), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF2E6930).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF2E6930).withOpacity(0.4))), child: Obx(() => Text("${controller.accuracy.value}%", style: const TextStyle(color: Color(0xFF34C759), fontWeight: FontWeight.w900, fontSize: 16))))]),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider(color: Color(0xFF27272A), height: 1)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(() => _buildSubMetricItem(Icons.timer_rounded, "WAKTU", controller.duration.value)), Container(width: 1, height: 24, color: const Color(0xFF27272A)), Obx(() => _buildSubMetricItem(Icons.local_fire_department_rounded, "KALORI", "${controller.calories.value.toStringAsFixed(1)} kcal", iconColor: Colors.orange)),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildSubMetricItem(IconData icon, String title, String val, {Color iconColor = const Color(0xFF2E6930)}) => Row(children: [Icon(icon, size: 18, color: iconColor), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFF71717A), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)), const SizedBox(height: 2), Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))])]);
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

          // =========================================================
          // PERUBAHAN TOMBOL: MULAI LATIHAN -> SELESAI SESI
          // =========================================================
          Obx(() => SizedBox(
            width: 160, height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Warna Hijau jika belum mulai, warna Merah jika sedang main
                  backgroundColor: controller.isPlaying.value ? Colors.redAccent : const Color(0xFF2E6930),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  elevation: 0
              ),
              onPressed: () {
                if (controller.isPlaying.value) {
                  controller.simpanHasilLatihan(); // STOP dan Pindah Halaman
                } else {
                  controller.mulaiLatihan(); // MULAI timer & hitungan rep
                }
              },
              child: Text(
                  controller.isPlaying.value ? "Stop / Selesai" : "Mulai Latihan",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
              ),
            ),
          )),

          Obx(() => _buildActionButton(controller.isMuted.value ? Icons.volume_off_rounded : Icons.volume_up_rounded, () => controller.toggleMute(), isActive: !controller.isMuted.value)),
        ],
      ),
    );
  }
  Widget _buildActionButton(IconData icon, VoidCallback onTap, {bool isActive = true}) => Container(decoration: BoxDecoration(color: const Color(0xFF18181B), shape: BoxShape.circle, border: Border.all(color: isActive ? const Color(0xFF27272A) : Colors.redAccent.withOpacity(0.5))), child: IconButton(icon: Icon(icon, color: isActive ? Colors.white : Colors.redAccent, size: 20), onPressed: onTap));
}

// =========================================================
// CUSTOM PAINTER: MELUKIS TITIK SENDI & TULANG
// =========================================================
class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final bool isFrontCamera;

  PosePainter(this.pose, this.imageSize, this.isFrontCamera);

  @override
  void paint(Canvas canvas, Size size) {
    final paintPoint = Paint()..color = const Color(0xFF34C759)..style = PaintingStyle.fill;
    final paintLine = Paint()..color = Colors.white70..strokeWidth = 4.0..style = PaintingStyle.stroke;

    double translateX(double x) {
      double mappedX = x * size.width / imageSize.width;
      return isFrontCamera ? size.width - mappedX : mappedX;
    }
    double translateY(double y) => y * size.height / imageSize.height;

    Offset getOffset(PoseLandmark landmark) => Offset(translateX(landmark.x), translateY(landmark.y));

    // BATAS DETEKSI 0.2 (Sangat peka)
    pose.landmarks.forEach((_, landmark) {
      if (landmark.likelihood > 0.2) canvas.drawCircle(getOffset(landmark), 6, paintPoint);
    });

    void drawBone(PoseLandmarkType t1, PoseLandmarkType t2) {
      final lm1 = pose.landmarks[t1]; final lm2 = pose.landmarks[t2];
      if (lm1 != null && lm2 != null && lm1.likelihood > 0.2 && lm2.likelihood > 0.2) {
        canvas.drawLine(getOffset(lm1), getOffset(lm2), paintLine);
      }
    }

    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    drawBone(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    drawBone(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    drawBone(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
    drawBone(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
    drawBone(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    drawBone(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
    drawBone(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
    drawBone(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) => true;
}