import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA),
      // Obx hanya membungkus area body yang memang dinamis berubah halamannya
      body: Obx(() => controller.pages[controller.currentIndex.value]),

      // Mengunci seluruh layout kontainer navigasi bawah menggunakan const
      bottomNavigationBar: const _FloatingBottomNavBar(),
    );
  }
}

// Komponen Navbar Terpisah (Mencegah Rebuild Massal ke Halaman Utama)
class _FloatingBottomNavBar extends StatelessWidget {
  const _FloatingBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _CustomNavItem(index: 0, label: 'Home'),
          _CustomNavItem(index: 1, label: 'Training'),
          _CustomNavItem(index: 2, label: 'Progress'),
          _CustomNavItem(index: 3, label: 'Settings'),
        ],
      ),
    );
  }
}

// Item Navigasi Terisolasi (Hanya merender ulang dirinya sendiri saat status aktif berubah)
class _CustomNavItem extends GetView<MainController> {
  final int index;
  final String label;

  const _CustomNavItem({
    required this.index,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque, // Memperluas area sensitivitas ketukan jari
      child: Obx(() {
        final bool isActive = controller.currentIndex.value == index;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isActive ? controller.iconActivePaths[index] : controller.iconPaths[index],
              width: 20,
              height: 16,
              cacheWidth: 40,  // Menghemat RAM dengan membatasi ukuran cache gambar di memory
              cacheHeight: 32, // Sesuaikan dengan skala aspect ratio icon asli
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? const Color(0xFF2E6930) : Colors.black38,
              ),
            ),
          ],
        );
      }),
    );
  }
}