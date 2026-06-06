import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA),
      body: Stack(
        children: [
          const _BlurEffect(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              // OBX MEMANTAU STATUS LOGIN
              child: Obx(() {
                final bool isAuth = controller.isLoggedIn.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeaderSection(),
                    const SizedBox(height: 24),

                    // Stats selalu tampil sebagai "Teaser" meskipun nilai 0 jika belum login
                    const _StreakAndWeatherSection(),
                    const SizedBox(height: 32),
                    const _DailyActivitySection(),

                    const SizedBox(height: 24),
                    const _FitnessCheckButton(),
                    const SizedBox(height: 32),

                    // Lempar status isAuth ke Quick Access untuk mengunci Latihan
                    _QuickAccessSection(isAuth: isAuth),
                    const SizedBox(height: 24),
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
        width: 200, height: 200,
        decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2E6930).withOpacity(0.15)),
      ),
    );
  }
}

class _HeaderSection extends GetView<HomeController> {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFFE8F5E9)),
              // --- TRANSLATOR PINTAR BASE64 DI HOME VIEW ---
              child: Obx(() {
                final String imgData = controller.profileImageUrl.value;

                if (imgData.isNotEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imgData.startsWith('data:image')
                        ? Image.memory(
                      base64Decode(imgData.split(',')[1]), // Sulap teks string jadi foto fisik
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildInitialAvatar(),
                    )
                        : Image.network(
                      imgData,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildInitialAvatar(),
                    ),
                  );
                } else {
                  return _buildInitialAvatar();
                }
              }),
            ),
            Obx(() => controller.isLoggedIn.value
                ? Positioned(
              bottom: -2, right: -2,
              child: Container(
                width: 14, height: 14,
                decoration: BoxDecoration(color: const Color(0xFF2ECC71), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Good Morning 🌿', style: TextStyle(color: Color(0xFF4E8D51), fontSize: 12, fontWeight: FontWeight.w600)),
            Obx(() => Text('Hello, ${controller.userName.value}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A)))),
          ],
        ),
        const Spacer(),
        Obx(() => controller.isLoggedIn.value
            ? Container(
          width: 45, height: 45,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.notifications_none_rounded, color: Color(0xFF1A1D1A)),
              Positioned(top: 12, right: 12, child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle))),
            ],
          ),
        )
            : GestureDetector(
          onTap: () => Get.toNamed('/login'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF2E6930), borderRadius: BorderRadius.circular(20)),
            child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        )),
      ],
    );
  }

  // Helper jika foto kosong / error, tampilkan huruf pertama nama user
  Widget _buildInitialAvatar() {
    return Center(
      child: Text(
        controller.userName.value.isNotEmpty ? controller.userName.value[0].toUpperCase() : 'G',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E6930)),
      ),
    );
  }
}

class _StreakAndWeatherSection extends StatelessWidget {
  const _StreakAndWeatherSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Streak', style: TextStyle(color: Colors.black38, fontSize: 12)), Text('0 Days', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))])
          ]),
          Container(height: 30, width: 1, color: Colors.grey.shade200),
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.cloud_queue_rounded, color: Colors.green, size: 20)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Cuaca', style: TextStyle(color: Colors.black38, fontSize: 12)), Text('22 °C', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))])
          ]),
        ],
      ),
    );
  }
}

class _DailyActivitySection extends StatelessWidget {
  const _DailyActivitySection();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Daily Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('Today', style: TextStyle(color: Color(0xFF2E6930), fontWeight: FontWeight.w600, fontSize: 14))]),
        const SizedBox(height: 16),
        Row(
          children: const [
            _ActivityCard(title: 'Training', icon: Icons.directions_walk_rounded, iconColor: Color(0xFF2E6930), value: '0', unit: 'Min', subtitle: 'Goal: 0', status: '0% complete', progressColor: Color(0xFF2E6930)),
            SizedBox(width: 16),
            _ActivityCard(title: 'Calories', icon: Icons.local_fire_department_outlined, iconColor: Colors.orange, value: '0', unit: 'kcal', subtitle: 'Target: 0', status: '0 kcal left', progressColor: Colors.orange),
          ],
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title, value, unit, subtitle, status;
  final IconData icon;
  final Color iconColor, progressColor;

  const _ActivityCard({required this.title, required this.icon, required this.iconColor, required this.value, required this.unit, required this.subtitle, required this.status, required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          children: [
            Row(children: [Icon(icon, color: iconColor, size: 18), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1D1A)), overflow: TextOverflow.ellipsis))]),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: 80, height: 80, child: CircularProgressIndicator(value: 0.02, strokeWidth: 8, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation<Color>(progressColor.withOpacity(0.2)))),
                Column(mainAxisSize: MainAxisSize.min, children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(unit, style: const TextStyle(fontSize: 10, color: Colors.black38))])
              ],
            ),
            const SizedBox(height: 24),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: 0.0, backgroundColor: Colors.grey.shade100, valueColor: AlwaysStoppedAnimation<Color>(progressColor), minHeight: 4)),
            const SizedBox(height: 6),
            Text(status, style: TextStyle(fontSize: 11, color: progressColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _FitnessCheckButton extends StatelessWidget {
  const _FitnessCheckButton();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF5B8C5A), Color(0xFF2E6930)]), borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: const Color(0xFF2E6930).withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 5))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => Get.toNamed('/cekkebugaran'),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.bolt_rounded, color: Colors.yellowAccent, size: 16)),
              const SizedBox(width: 12),
              const Text('CEK KEBUGARAN', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// LOGIKA PENGUNCIAN LATIHAN BERADA DI SINI
class _QuickAccessSection extends StatelessWidget {
  final bool isAuth;
  const _QuickAccessSection({required this.isAuth});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Icon(Icons.grid_view_rounded, color: Colors.black38, size: 20)]),
        const SizedBox(height: 16),
        Row(
          children: [
            _AccessCard(
                title: 'Mulai\nTraining',
                subtitle: isAuth ? 'Begin now' : 'Locked', // Berubah jika belum login
                icon: isAuth ? Icons.fitness_center_rounded : Icons.lock_rounded, // Ikon gembok
                imagePath: 'assets/training/training.png',
                isLocked: !isAuth, // Kirim status kunci ke UI kartu
                onTap: () {
                  if (!isAuth) {
                    // POP-UP PERINGATAN KETIKA GUEST KLIK LATIHAN
                    Get.defaultDialog(
                        title: "Fitur Terkunci",
                        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                        middleText: "Silakan Login atau Register untuk memulai program Training.",
                        textConfirm: "Login Sekarang",
                        textCancel: "Batal",
                        confirmTextColor: Colors.white,
                        cancelTextColor: const Color(0xFF2E6930),
                        buttonColor: const Color(0xFF2E6930),
                        onConfirm: () {
                          Get.back();
                          Get.toNamed('/login');
                        }
                    );
                    return;
                  }

                  // Jika sudah login, lanjut ke halaman Latihan
                  if (Get.isRegistered<dynamic>(tag: 'MainController')) {
                    Get.find<dynamic>(tag: 'MainController').changePage(1);
                  } else {
                    Get.offAllNamed('/main', arguments: 1);
                  }
                }
            ),
            const SizedBox(width: 16),
            _AccessCard(
                title: 'Plan Mountain\nTrip',
                subtitle: 'Explore',
                icon: Icons.terrain_rounded,
                imagePath: 'assets/training/mount.png',
                isLocked: false, // Perjalanan Gunung selalu terbuka
                onTap: () => Get.toNamed('/listgunung')
            ),
          ],
        ),
      ],
    );
  }
}

class _AccessCard extends StatelessWidget {
  final String title, subtitle, imagePath;
  final IconData icon;
  final bool isLocked;
  final VoidCallback onTap;

  const _AccessCard({required this.title, required this.subtitle, required this.icon, required this.imagePath, required this.onTap, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180, padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))],
              color: Colors.grey.shade800,
              image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  // Jika dikunci, overlay hitamnya akan lebih tebal (gelap)
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(isLocked ? 0.7 : 0.35), BlendMode.darken)
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: isLocked ? Colors.redAccent.withOpacity(0.8) : Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle
                  ),
                  child: Icon(icon, color: Colors.white, size: 18)
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isLocked ? Colors.white70 : Colors.white, fontSize: 15, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 8),
                  Row(
                      children: [
                        Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.play_arrow_rounded, color: Colors.black87, size: 12)),
                        const SizedBox(width: 6),
                        Text(subtitle, style: TextStyle(color: isLocked ? Colors.redAccent : Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                      ]
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}