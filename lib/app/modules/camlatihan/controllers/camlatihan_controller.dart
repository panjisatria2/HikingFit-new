import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class CamlatihanController extends GetxController {
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxInt selectedCameraIndex = 1.obs; // Kamera Depan

  // --- METRICS DATA LATIHAN ---
  final RxString currentExercise = "Squat".obs;
  final RxInt repsCount = 0.obs;
  final RxInt accuracy = 0.obs;
  final RxString duration = "00:00".obs;
  final RxDouble calories = 0.0.obs;
  final RxBool isMuted = false.obs;

  // --- MESIN AI & TIMER ---
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _isProcessingFrame = false;
  bool _isDown = false;

  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      currentExercise.value = Get.arguments['exercise_name'] ?? "Squat";
    }
    initCamera(selectedCameraIndex.value);
    _startTimer(); // Nyalakan stopwatch
  }

  // --- LOGIKA WAKTU (TIMER) ---
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      int minutes = _secondsElapsed ~/ 60;
      int seconds = _secondsElapsed % 60;
      duration.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  Future<void> initCamera(int cameraIndex) async {
    try {
      isCameraInitialized.value = false;
      final cameras = await availableCameras();

      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras[cameraIndex], ResolutionPreset.high, enableAudio: false,
          imageFormatGroup: ImageFormatGroup.yuv420,
        );

        await cameraController!.initialize();
        isCameraInitialized.value = true;

        cameraController!.startImageStream((CameraImage image) {
          if (!_isProcessingFrame) {
            _isProcessingFrame = true;
            _processCameraImage(image, cameras[cameraIndex]);
          }
        });
      } else {
        _showErrorSnackbar("Kamera tidak ditemukan.");
      }
    } catch (e) {
      _showErrorSnackbar("Gagal mengakses kamera: $e");
    }
  }

  Future<void> _processCameraImage(CameraImage image, CameraDescription camera) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
      final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      // =================================================================
      // PERBAIKAN: FORMAT PENULISAN UNTUK ML KIT VERSI TERBARU
      // =================================================================
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: image.planes.first.bytesPerRow, // Cukup ambil dari plane pertama
        ),
      );

      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        _routerGerakan(poses.first);
      }
    } catch (e) {
      debugPrint("Error AI: $e");
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _routerGerakan(Pose pose) {
    switch (currentExercise.value) {
      case "Squat":
      case "Squats": _evaluateSquat(pose); break;
      case "Lunges": _evaluateLunges(pose); break;
      case "Plank": _evaluatePlank(pose); break;
      default: break;
    }
  }

  void _evaluateSquat(Pose pose) {
    final hip = pose.landmarks[PoseLandmarkType.leftHip];
    final knee = pose.landmarks[PoseLandmarkType.leftKnee];
    final ankle = pose.landmarks[PoseLandmarkType.leftAnkle];

    if (hip != null && knee != null && ankle != null && hip.likelihood > 0.5) {
      double angle = _calculateAngle(hip, knee, ankle);
      if (angle < 100.0) {
        _isDown = true; accuracy.value = 95;
      } else if (angle > 160.0 && _isDown) {
        repsCount.value++; calories.value += 0.3; _isDown = false; accuracy.value = 100;
      } else if (angle > 100.0 && angle < 140.0 && !_isDown) {
        accuracy.value = 45;
      }
    }
  }

  void _evaluateLunges(Pose pose) {
    final hip = pose.landmarks[PoseLandmarkType.rightHip];
    final knee = pose.landmarks[PoseLandmarkType.rightKnee];
    final ankle = pose.landmarks[PoseLandmarkType.rightAnkle];

    if (hip != null && knee != null && ankle != null && hip.likelihood > 0.5) {
      double angle = _calculateAngle(hip, knee, ankle);
      if (angle < 95.0) {
        _isDown = true; accuracy.value = 90;
      } else if (angle > 150.0 && _isDown) {
        repsCount.value++; calories.value += 0.25; _isDown = false; accuracy.value = 100;
      }
    }
  }

  void _evaluatePlank(Pose pose) {
    final shoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final hip = pose.landmarks[PoseLandmarkType.leftHip];
    final ankle = pose.landmarks[PoseLandmarkType.leftAnkle];

    if (shoulder != null && hip != null && ankle != null && shoulder.likelihood > 0.5) {
      double bodyAngle = _calculateAngle(shoulder, hip, ankle);
      if (bodyAngle > 160.0) {
        accuracy.value = 100; calories.value += 0.05; // Kalori plank naik per frame
      } else if (bodyAngle < 150.0) {
        accuracy.value = 40;
      }
    }
  }

  double _calculateAngle(PoseLandmark first, PoseLandmark mid, PoseLandmark last) {
    final result = math.atan2(last.y - mid.y, last.x - mid.x) - math.atan2(first.y - mid.y, first.x - mid.x);
    var angle = (result * 180 / math.pi).abs();
    if (angle > 180.0) angle = 360.0 - angle;
    return angle;
  }

  // =================================================================
  // FUNGSI SELESAI & PINDAH KE HALAMAN RESUME
  // =================================================================
  Future<void> simpanHasilLatihan() async {
    if (repsCount.value == 0 && currentExercise.value != "Plank") {
      Get.back(); return;
    }

    // Matikan stream kamera & timer agar tidak bocor di RAM
    await cameraController?.stopImageStream();
    _poseDetector.close();
    _timer?.cancel();

    // Lempar data ke halaman Resume
    Get.offNamed('/resumelatihan', arguments: {
      'exercise_name': currentExercise.value,
      'total_reps': repsCount.value,
      'accuracy': accuracy.value,
      'duration': duration.value,
      'calories': calories.value,
    });
  }

  Future<void> toggleCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return;
    selectedCameraIndex.value = selectedCameraIndex.value == 0 ? 1 : 0;
    await cameraController?.stopImageStream();
    if (cameraController != null) await cameraController!.dispose();
    await initCamera(selectedCameraIndex.value);
  }

  void toggleMute() { isMuted.value = !isMuted.value; }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, backgroundColor: Colors.redAccent, colorText: Colors.white);
  }

  @override
  void onClose() {
    _timer?.cancel();
    cameraController?.stopImageStream();
    cameraController?.dispose();
    _poseDetector.close();
    super.onClose();
  }
}