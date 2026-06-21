import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CamlatihanController extends GetxController {
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxInt selectedCameraIndex = 1.obs;

  // --- DATA SKELETON (UNTUK DILUKIS DI VIEW) ---
  final Rx<Pose?> currentPose = Rx<Pose?>(null);
  Size cameraImageSize = Size.zero;
  bool isFrontCamera = true;

  // --- STATE MULAI/STOP LATIHAN ---
  final RxBool isPlaying = false.obs; // Default false (Belum Mulai)

  // --- METRICS ---
  final RxString currentExercise = "Squat".obs;
  final RxInt repsCount = 0.obs;
  final RxInt accuracy = 0.obs;
  final RxString duration = "00:00".obs;
  final RxDouble calories = 0.0.obs;
  final RxBool isMuted = false.obs;

  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _isProcessingFrame = false;
  bool _isDown = false;
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) currentExercise.value = Get.arguments['exercise_name'] ?? "Squat";
    initCamera(selectedCameraIndex.value);
    // Timer TIDAK LAGI dijalan di onInit.
  }

  // Fungsi dipanggil saat tombol "Mulai" ditekan
  void mulaiLatihan() {
    isPlaying.value = true;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
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
        isFrontCamera = cameraIndex == 1;
        cameraController = CameraController(
          cameras[cameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
        );

        await cameraController!.initialize();
        isCameraInitialized.value = true;

        cameraController!.startImageStream((CameraImage image) {
          if (!_isProcessingFrame) {
            _isProcessingFrame = true;
            _processCameraImage(image, cameras[cameraIndex]);
          }
        });
      }
    } catch (e) {
      debugPrint("Error Kamera: $e");
    }
  }

  Future<void> _processCameraImage(CameraImage image, CameraDescription camera) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) { allBytes.putUint8List(plane.bytes); }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
      final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ?? InputImageRotation.rotation0deg;
      final inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: imageSize,
          rotation: imageRotation,
          format: inputImageFormat,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        bool isPortrait = camera.sensorOrientation == 90 || camera.sensorOrientation == 270;
        cameraImageSize = isPortrait ? Size(image.height.toDouble(), image.width.toDouble()) : imageSize;

        currentPose.value = poses.first;
        currentPose.refresh();

        _routerGerakan(poses.first);
      } else {
        currentPose.value = null;
        currentPose.refresh();
      }
    } catch (e) {
      debugPrint("Error AI: $e");
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _routerGerakan(Pose pose) {
    if (currentExercise.value.contains("Squat")) _evaluateSquat(pose);
    else if (currentExercise.value.contains("Lunges")) _evaluateLunges(pose);
    else if (currentExercise.value.contains("Plank")) _evaluatePlank(pose);
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
        _isDown = false; accuracy.value = 100;

        // HANYA MENGHITUNG REP JIKA SUDAH DITEKAN MULAI
        if (isPlaying.value) {
          repsCount.value++; calories.value += 0.3;
        }
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
        _isDown = false; accuracy.value = 100;
        if (isPlaying.value) { repsCount.value++; calories.value += 0.25; }
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
        accuracy.value = 100;
        if (isPlaying.value) calories.value += 0.05;
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

  // Fungsi dipanggil saat tombol "Stop / Selesai Sesi" ditekan
  Future<void> simpanHasilLatihan() async {
    isPlaying.value = false;

    Get.snackbar('Menyimpan...', 'Merekam hasil latihan ke Cloud...', showProgressIndicator: true, snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);

    await cameraController?.stopImageStream();
    _poseDetector.close();
    _timer?.cancel();

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('training_history').add({
          'uid': currentUser.uid,
          'exercise_name': currentExercise.value,
          'total_reps': repsCount.value,
          'accuracy': accuracy.value,
          'duration': duration.value,
          'calories': calories.value,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("Gagal simpan ke Firebase: $e");
    }

    Get.offNamed('/resumelatihan', arguments: {
      'exercise_name': currentExercise.value,
      'total_reps': repsCount.value,
      'accuracy': accuracy.value,
      'duration': duration.value,
      'calories': calories.value,
    });
  }

  void toggleCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return;
    selectedCameraIndex.value = selectedCameraIndex.value == 0 ? 1 : 0;
    await cameraController?.stopImageStream();
    if (cameraController != null) await cameraController!.dispose();
    await initCamera(selectedCameraIndex.value);
  }

  void toggleMute() { isMuted.value = !isMuted.value; }

  @override
  void onClose() {
    _timer?.cancel();
    cameraController?.stopImageStream();
    cameraController?.dispose();
    _poseDetector.close();
    super.onClose();
  }
}