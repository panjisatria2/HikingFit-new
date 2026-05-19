import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          const _BlurEffect(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Obx(() {
                final bool isAuth = controller.isLoggedIn.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeaderSection(),
                    const SizedBox(height: 32),
                    const _ProfileCardSection(),

                    // --- PERSONAL INFO HANYA TAMPIL JIKA SUDAH LOGIN ---
                    if (isAuth) ...[
                      const SizedBox(height: 32),
                      const _SectionTitle(title: 'PERSONAL INFO'),
                      const SizedBox(height: 16),
                      const _PersonalInfoCard(),
                    ],

                    const SizedBox(height: 32),
                    const _SectionTitle(title: 'PREFERENCES'),
                    const SizedBox(height: 16),
                    const _PreferencesCard(),

                    const SizedBox(height: 32),
                    const _SectionTitle(title: 'ACCOUNT'),
                    const SizedBox(height: 16),
                    const _AccountCard(),

                    // --- TOMBOL LOGOUT HANYA TAMPIL JIKA SUDAH LOGIN ---
                    if (isAuth) ...[
                      const SizedBox(height: 32),
                      const _SignOutCard(),
                    ],

                    const SizedBox(height: 100), // Jarak aman dari floating navbar
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
// IMPLEMENTASI SUB-WIDGETS YANG BERSIH & STANDAR FLUTTER
// =========================================================

class _BlurEffect extends StatelessWidget {
  const _BlurEffect({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
      right: -50,
      child: Container(
        width: 200, height: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4A7C59).withOpacity(0.1)
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFE8F1E8), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.eco_rounded, color: Color(0xFF4A7C59), size: 20),
        ),
      ],
    );
  }
}

class _ProfileCardSection extends GetView<SettingController> {
  const _ProfileCardSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Obx(() {
        final bool isAuth = controller.isLoggedIn.value;

        return Row(
          children: [
            // --- AVATAR DENGAN INISIAL HURUF (SAMA DENGAN HOME) ---
            Stack(
              children: [
                Container(
                  width: 65, height: 65,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8F1E8), // Hijau pudar elegan
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    // Mengambil huruf pertama dari nama user secara dinamis
                    child: Text(
                      controller.fullName.value.isNotEmpty
                          ? controller.fullName.value[0].toUpperCase()
                          : 'G',
                      style: const TextStyle(
                          fontSize: 28, // Ukuran huruf lebih besar
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A7C59)
                      ),
                    ),
                  ),
                ),
                // Titik status Online (Hanya tampil jika sudah login)
                if (isAuth)
                  Positioned(
                    bottom: -2, right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3), // Padding sedikit lebih besar
                      decoration: BoxDecoration(
                          color: const Color(0xFF2E5B2C), // Hijau tua status
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5) // Border putih
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.fullName.value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Antisipasi nama terlalu panjang
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAuth ? 'Status BMI: ${controller.bmiStatus.value}' : 'Status: Guest Mode 🌿',
                    style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (!isAuth)
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed('/login'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFF4A7C59), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => Get.toNamed('/register'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: const Color(0xFFE8F1E8), borderRadius: BorderRadius.circular(12)),
                      child: const Text('Register', style: TextStyle(color: Color(0xFF4A7C59), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
    );
  }
}

class _PersonalInfoCard extends GetView<SettingController> {
  const _PersonalInfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF1F8F1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.scale_rounded, color: Color(0xFF4A7C59)),
            ),
            title: const Text('Weight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Body weight', style: TextStyle(fontSize: 12)),
            trailing: Obx(() => Text('${controller.weight.value} kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E5B2C)))),
          ),
          const Divider(height: 1, indent: 70),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF1F8F1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.height_rounded, color: Color(0xFF4A7C59)),
            ),
            title: const Text('Height', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Body height', style: TextStyle(fontSize: 12)),
            trailing: Obx(() => Text('${controller.height.value} cm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E5B2C)))),
          ),
        ],
      ),
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFFFF9E6), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.notifications_rounded, color: Colors.amber, size: 20),
        ),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: const Text('Push & alerts', style: TextStyle(fontSize: 12)),
        trailing: Switch(
          value: true,
          onChanged: (val) {},
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF4A7C59),
        ),
      ),
    );
  }
}

class _AccountCard extends GetView<SettingController> {
  const _AccountCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Obx(() {
        final bool isAuth = controller.isLoggedIn.value;

        return Column(
          children: [
            ListTile(
              onTap: () => isAuth ? Get.toNamed('/ubahprofil') : controller.showGuestWarning(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFEDF2FF), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.person_outline_rounded, color: Colors.blueAccent),
              ),
              title: const Text('Ubah Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Security settings', style: TextStyle(fontSize: 12)),
              trailing: Icon(
                  isAuth ? Icons.arrow_forward_ios_rounded : Icons.lock_outline_rounded,
                  size: 14,
                  color: Colors.grey
              ),
            ),
            const Divider(height: 1, indent: 70),
            ListTile(
              onTap: () => isAuth ? Get.toNamed('/ubahpass') : controller.showGuestWarning(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFEDF2FF), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.lock_outline_rounded, color: Colors.blueAccent),
              ),
              title: const Text('Ubah Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Security settings', style: TextStyle(fontSize: 12)),
              trailing: Icon(
                  isAuth ? Icons.arrow_forward_ios_rounded : Icons.lock_outline_rounded,
                  size: 14,
                  color: Colors.grey
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _SignOutCard extends GetView<SettingController> {
  const _SignOutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- IKON HEADER ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- JUDUL ---
                    const Text(
                      "Logout Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D1A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- DESKRIPSI ---
                    const Text(
                      "Are you sure you want to exit or switch to another account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- TOMBOL AKSI SEJAJAR ---
                    Row(
                      children: [
                        // Tombol Batal
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFEFEFEF), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () => Get.back(),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // Jarak antar tombol

                        // Tombol Keluar
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              Get.back(); // Tutup dialog dulu
                              controller.handleLogout(); // Eksekusi fungsi logout
                            },
                            child: const Text(
                              "Yes, Logout",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false, // Opsi: Mencegah user menutup dialog dengan klik area luar
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout Account',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}