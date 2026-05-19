import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/detailgunung/controllers/detailgunung_controller.dart';

class DetailgunungView extends GetView<DetailgunungController> {
  const DetailgunungView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA), // Clean modern background
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeaderImageSection(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: _MainContentSection(),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// PREMIUM PROFESSIONAL SUB-WIDGETS
// =========================================================

class _HeaderImageSection extends StatelessWidget {
  const _HeaderImageSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Image Asset
        Container(
          height: 350,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
            child: Image.asset(
              'assets/gunung/prau.png',
              fit: BoxFit.cover,
              cacheWidth: 900,
            ),
          ),
        ),
        // Dark Vignette Gradient for Text Readability
        Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.25),
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
        // Floating Back Button
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D1A), size: 18),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        // Mountain Name, Badge, and Global Rating Placement
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E6930),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '2.565 MDPL',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // GLOBAL RATING BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text(
                          '4.9 (120 ulasan)',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Gunung Prau",
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _MainContentSection extends StatelessWidget {
  const _MainContentSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // --- SEKSI TENTANG GUNUNG ---
        _SectionTitle(title: 'Tentang Gunung'),
        SizedBox(height: 12),
        Text(
          "Gunung Prau merupakan salah satu destinasi pendakian terfavorit di Jawa Tengah yang terkenal dengan keindahan panorama lanskap dataran tinggi Dieng. Karakteristik jalurnya cenderung bersahabat bagi pendaki, menjadikannya tempat terbaik untuk menikmati pemandangan alam bebas yang memukau.",
          style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), height: 1.6, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 24),

        // Metadata Ringkas Grid
        _MountainMetaGrid(),

        SizedBox(height: 36),

        // --- DAFTAR JALUR ---
        _SectionTitle(title: 'Jalur Pendakian Resmi'),
        SizedBox(height: 16),
        _PathCard(
          pathName: 'Jalur Patak Banteng',
          story: 'Jalur paling populer dan efisien dengan waktu tempuh tersingkat. Jalur ini langsung menyajikan pemandangan Telaga Warna dari ketinggian rute.',
          difficulty: 'Light',
        ),
        _PathCard(
          pathName: 'Jalur Dieng Kulon',
          story: 'Jalur santai dengan tanjakan landai. Sangat cocok bagi pendaki yang ingin menikmati sabana luas secara rileks.',
          difficulty: 'Easy',
        ),

        SizedBox(height: 36),

        // --- ULASAN USER ---
        _SectionTitle(title: 'Ulasan Komunitas'),
        SizedBox(height: 16),
        _UserReviewCard(name: 'Panji Satria', rating: '5.0', comment: 'Golden Sunrise-nya juara banget! Jalur Patak Banteng cukup padat pas weekend, mending naik pas weekday.'),
        _UserReviewCard(name: 'Heru Mudzaqi', rating: '4.8', comment: 'Track-nya cocok banget buat melatih fisik pemula sebelum naik gunung yang lebih tinggi.'),

        SizedBox(height: 36),

        // --- KOLOM KOMENTAR ---
        _SectionTitle(title: 'Diskusi & Pertanyaan'),
        SizedBox(height: 12),
        _CommentInputBox(),
        SizedBox(height: 20),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A), letterSpacing: -0.3),
    );
  }
}

class _MountainMetaGrid extends StatelessWidget {
  const _MountainMetaGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMetaBox(Icons.map_outlined, 'Lokasi', 'Wonosobo, Jateng'),
        const SizedBox(width: 12),
        _buildMetaBox(Icons.timer_outlined, 'Waktu Tempuh', '± 3 - 4 Jam'),
        const SizedBox(width: 12),
        _buildMetaBox(Icons.thermostat_rounded, 'Suhu Rata-rata', '15°C - 22°C'),
      ],
    );
  }

  Widget _buildMetaBox(IconData icon, String title, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEFEF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF2E6930)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A)), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  final String pathName;
  final String story;
  final String difficulty;

  const _PathCard({
    required this.pathName,
    required this.story,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pathName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                child: Text(difficulty, style: const TextStyle(color: Color(0xFF2E6930), fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(story, style: const TextStyle(color: Color(0xFF666666), fontSize: 13, height: 1.5)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/detailjalur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6930),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Lihat Detail Jalur & Pos', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserReviewCard extends StatelessWidget {
  final String name;
  final String rating;
  final String comment;

  const _UserReviewCard({
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE8F5E9),
                radius: 14,
                child: Text(name[0], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E6930))),
              ),
              const SizedBox(width: 10),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1D1A))),
              const Spacer(),
              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(color: Color(0xFF555555), fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}

class _CommentInputBox extends StatelessWidget {
  const _CommentInputBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Tuliskan pengalaman atau pertanyaan...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Color(0xFF2E6930), size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}