import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/listlatihan/controllers/listlatihan_controller.dart';

class ListlatihanView extends GetView<ListlatihanController> {
  const ListlatihanView({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // KUNCI PERBAIKAN: PAKSA CEK TOKEN SETIAP HALAMAN DIBUKA
    // =========================================================
    controller.checkLoginStatus();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          const _BlurEffect(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Obx(() {
                // Memantau status login secara reaktif
                final bool isAuth = controller.isLoggedIn.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const _HeaderSection(),
                    const SizedBox(height: 24),
                    const _CategoriesSection(),
                    const SizedBox(height: 32),

                    // Passing isAuth ke title dan list kartu
                    _SubtitleSection(isAuth: isAuth),
                    const SizedBox(height: 16),
                    _ExerciseListSection(isAuth: isAuth),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// OPTIMIZED SUB-WIDGETS
// =========================================================

class _BlurEffect extends StatelessWidget {
  const _BlurEffect();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: -50,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF4A7C59).withOpacity(0.15),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'HikeFit ',
                style: TextStyle(
                  color: Color(0xFF4A7C59),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Icon(Icons.eco, color: Color(0xFF4A7C59), size: 16),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Rencanakan Pelatihan',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: const [
          _CategoryChip(label: 'All', isActive: true),
          _CategoryChip(label: 'Beginner', isActive: false),
          _CategoryChip(label: 'Intermediate', isActive: false),
          _CategoryChip(label: 'Advanced', isActive: false),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _CategoryChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2E5B2C) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: isActive ? null : Border.all(color: Colors.grey.shade300),
        boxShadow: isActive
            ? [BoxShadow(color: const Color(0xFF2E5B2C).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade600,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}

class _SubtitleSection extends StatelessWidget {
  final bool isAuth;
  const _SubtitleSection({required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Latihan Persiapan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            isAuth ? '5 Latihan' : '🔒 Locked',
            style: TextStyle(
                fontSize: 14,
                color: isAuth ? Colors.green.shade600 : Colors.redAccent,
                fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseListSection extends StatelessWidget {
  final bool isAuth;
  const _ExerciseListSection({required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _ExerciseCard(
            title: 'Squat', // Ubah jadi "Squat" agar match dengan rumus Controller AI
            subtitle: 'Lower body strength & balance',
            imagePath: 'assets/training/squat.png',
            level: 'Beginner',
            duration: '10 mins',
            kcal: '45 kcal',
            isBeginner: true,
            isLocked: !isAuth,
          ),
          _ExerciseCard(
            title: 'Lunges',
            subtitle: 'Leg strength & hip flexibility',
            imagePath: 'assets/training/lunges.png',
            level: 'Beginner',
            duration: '12 mins',
            kcal: '52 kcal',
            isBeginner: true,
            isLocked: !isAuth,
          ),
          _ExerciseCard(
            title: 'Step-Up',
            subtitle: 'Mimics uphill hiking motion',
            imagePath: 'assets/training/stepup.png',
            level: 'Intermediate',
            duration: '15 mins',
            kcal: '68 kcal',
            isBeginner: false,
            isLocked: !isAuth,
          ),
          _ExerciseCard(
            title: 'Calf Raises',
            subtitle: 'Ankle strength & stability',
            imagePath: 'assets/training/calf_raises.png',
            level: 'Beginner',
            duration: '8 mins',
            kcal: '30 kcal',
            isBeginner: true,
            isLocked: !isAuth,
          ),
          _ExerciseCard(
            title: 'Plank',
            subtitle: 'Plank strength & stability',
            imagePath: 'assets/training/plank.png',
            level: 'Intermediate',
            duration: '5 mins',
            kcal: '70 kcal',
            isBeginner: false,
            isLocked: !isAuth,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ExerciseCard extends GetView<ListlatihanController> {
  final String title;
  final String subtitle;
  final String imagePath;
  final String level;
  final String duration;
  final String kcal;
  final bool isBeginner;
  final bool isLocked;

  const _ExerciseCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.level,
    required this.duration,
    required this.kcal,
    required this.isBeginner,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          controller.showGuestWarning();
          return;
        }
        // =========================================================
        // PENTING: MENGIRIM NAMA OLAHRAGA KE HALAMAN KAMERA
        // =========================================================
        Get.toNamed('/camlatihan', arguments: {'exercise_name': title});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  color: isLocked ? Colors.black.withOpacity(0.4) : null,
                  colorBlendMode: isLocked ? BlendMode.darken : null,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, color: Colors.grey);
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.black45 : Colors.black87
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey.shade100
                              : (isBeginner ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          level,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isLocked
                                ? Colors.grey
                                : (isBeginner ? const Color(0xFF2E6930) : Colors.orange.shade700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(duration, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: isLocked ? Colors.grey.shade100 : const Color(0xFFE8F5E9),
                  shape: BoxShape.circle
              ),
              child: Icon(
                  isLocked ? Icons.lock_rounded : Icons.play_arrow_rounded,
                  color: isLocked ? Colors.grey.shade500 : const Color(0xFF2E6930),
                  size: 24
              ),
            ),
          ],
        ),
      ),
    );
  }
}