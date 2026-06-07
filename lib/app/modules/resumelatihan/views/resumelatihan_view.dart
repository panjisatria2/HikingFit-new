import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/resumelatihan_controller.dart';

class ResumelatihanView extends GetView<ResumelatihanController> {
  const ResumelatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9), shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFF2E6930).withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.emoji_events_rounded, color: Color(0xFF2E6930), size: 80),
              ),
              const SizedBox(height: 32),
              const Text("Latihan Selesai!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Obx(() => Text("Sesi ${controller.exerciseName.value} Anda telah terekam.", style: TextStyle(fontSize: 14, color: Colors.grey.shade600))),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Obx(() => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.repeat_rounded, "Repetisi", "${controller.totalReps.value}x"),
                        _buildStatItem(Icons.analytics_rounded, "Akurasi", "${controller.accuracy.value}%"),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Color(0xFFEEEEEE))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.timer_rounded, "Durasi", controller.duration.value),
                        _buildStatItem(Icons.local_fire_department_rounded, "Kalori", "${controller.calories.value.toStringAsFixed(1)} kcal", isOrange: true),
                      ],
                    ),
                  ],
                )),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6930), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0,
                  ),
                  onPressed: () => controller.kembaliKeBeranda(),
                  child: const Text("Kembali ke Beranda", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, {bool isOrange = false}) {
    return Column(
      children: [
        Icon(icon, color: isOrange ? Colors.orange.shade600 : const Color(0xFF2E6930), size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ],
    );
  }
}