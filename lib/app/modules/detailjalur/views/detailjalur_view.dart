import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/detailjalur/controllers/detailjalur_controller.dart';

class DetailjalurView extends GetView<DetailjalurController> {
  const DetailjalurView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _HeaderImageSection(),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: _MainContentContainer(),
                ),
              ],
            ),
          ),
          const _BottomActionButtons(),
        ],
      ),
    );
  }
}

// =========================================================
// OPTIMIZED PROFESSIONAL SUB-WIDGETS (STATELESS CLASS)
// =========================================================

class _HeaderImageSection extends StatelessWidget {
  const _HeaderImageSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            child: Image.asset(
              'assets/gunung/prau.png',
              fit: BoxFit.cover,
              cacheWidth: 800,
            ),
          ),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Route Analysis", style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text("Gunung Prau", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }
}

class _MainContentContainer extends StatelessWidget {
  const _MainContentContainer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _StatBadgesSection(),
        SizedBox(height: 24),
        _TrailStorySection(),
        SizedBox(height: 24),
        _TrailRouteSection(),
        SizedBox(height: 28),

        // --- INFORMASI & REGULASI MUNCAK.ID ---
        _InfoAndRulesSection(),
        SizedBox(height: 32),

        Text(
          'Rekomendasi Latihan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A)),
        ),
        SizedBox(height: 16),
        _ExerciseCard(
          title: 'Squats',
          sub: 'Lower body strength & balance',
          img: 'assets/training/squat.png',
        ),
        SizedBox(height: 140), // Jaga jarak napas dari floating button bawah
      ],
    );
  }
}

class _StatBadgesSection extends StatelessWidget {
  const _StatBadgesSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _BadgeItem(icon: Icons.terrain_rounded, color: Colors.grey, label: "2.565 mdpl"),
        _BadgeItem(icon: Icons.cloud_rounded, color: Colors.blue, label: "22°C"),
        _BadgeItem(icon: Icons.trending_up_rounded, color: Colors.orange, label: "2101 m"),
        _BadgeItem(icon: Icons.map_rounded, color: Colors.green, label: "9.95 km"),
        _BadgeItem(icon: Icons.timer_rounded, color: Colors.redAccent, label: "6.4 jam"),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _BadgeItem({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1A1D1A))),
        ],
      ),
    );
  }
}

class _TrailStorySection extends StatelessWidget {
  const _TrailStorySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Tentang Jalur Patak Banteng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
        SizedBox(height: 12),
        Text(
          "Jalur Patak Banteng merupakan rute favorit karena waktu tempuh singkat, sekitar 2-3 jam. Jalurnya curam 'dengkul ketemu dada' namun terbayar dengan pesona Golden Sunrise terbaik.",
          style: TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.5),
        ),
      ],
    );
  }
}

class _TrailRouteSection extends StatelessWidget {
  const _TrailRouteSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Trail Route", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1D1A))),
          const SizedBox(height: 30),
          Row(
            children: const [
              _PosNode(title: "Pos 1", subtitle: "Start"),
              _RouteLine(time: "1.2h"),
              _PosNode(title: "Pos 2", subtitle: "70m"),
              _RouteLine(time: "0.8h"),
              _PosNode(title: "Pos 3", subtitle: "90m"),
              _RouteLine(time: "1.5h"),
              _PosNode(title: "Puncak", subtitle: "Finish"),
            ],
          ),
        ],
      ),
    );
  }
}

class _PosNode extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PosNode({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(color: Color(0xFF2E6930), shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
        Text(subtitle, style: const TextStyle(fontSize: 8, color: Colors.grey)),
      ],
    );
  }
}

class _RouteLine extends StatelessWidget {
  final String time;

  const _RouteLine({required this.time});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(height: 2, color: const Color(0xFFEFEFEF)),
          Positioned(
            top: -15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                time,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2E6930)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// INTEGRASI DATA INFORMASI & REGULASI MUNCAK.ID
class _InfoAndRulesSection extends StatelessWidget {
  const _InfoAndRulesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Informasi & Regulasi Sesuai Muncak.id', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEFEFEF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF2E6930), size: 18),
                  SizedBox(width: 8),
                  Text('Syarat Pendakian Resmi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1D1A))),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '• Wajib membawa kartu identitas asli (KTP/Passport) untuk proses registrasi.\n• Pendaki disarankan membawa surat keterangan sehat jasmani.\n• Kuota pendakian harian dibatasi demi kelestarian ekosistem kawasan.',
                style: TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Color(0xFFEFEFEF), height: 1),
              ),
              Row(
                children: const [
                  Icon(Icons.gavel_rounded, color: Colors.amber, size: 18),
                  SizedBox(width: 8),
                  Text('Aturan & Larangan Utama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A1D1A))),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '• Dilarang keras membawa tisu basah ke atas gunung.\n• Wajib membawa sampah logistik turun kembali ke basecamp.\n• Dilarang memetik atau merusak tanaman edelweis dan flora lokal lainnya.\n• Camping hanya diperkenankan di area camp ground resmi yang ditentukan.',
                style: TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final String title;
  final String sub;
  final String img;

  const _ExerciseCard({required this.title, required this.sub, required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              img,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade100,
                child: const Icon(Icons.fitness_center_rounded, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
                Text(sub, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Text("Beginner", style: TextStyle(color: Color(0xFF2E6930), fontSize: 10, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, size: 10, color: Colors.grey),
                    Text(" 10 mins", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.play_arrow_rounded, color: Color(0xFF2E6930)),
          )
        ],
      ),
    );
  }
}

class _BottomActionButtons extends StatelessWidget {
  const _BottomActionButtons();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.toNamed('/main', arguments: 1), // Mengarahkan ke rute folder training (/main index 1)
                icon: const Icon(Icons.directions_walk_rounded, size: 18),
                label: const Text("Start Training", style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E6930),
                  side: const BorderSide(color: Color(0xFF2E6930)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/cekkebugaran'),
                icon: const Icon(Icons.bolt, size: 18, color: Colors.yellowAccent),
                label: const Text("Cek Kebugaran", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6930),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}