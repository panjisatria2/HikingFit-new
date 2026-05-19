import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/cekkebugaran/controllers/cekkebugaran_controller.dart';

class CekkebugaranView extends GetView<CekkebugaranController> {
  const CekkebugaranView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B), // Deep Dark Background
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _HeaderSection(),
                  SizedBox(height: 40),
                  _FinalScoreCard(),
                  SizedBox(height: 16),
                  _MiniStatsRow(),
                  SizedBox(height: 32),
                  _RecommendationHeader(),
                  SizedBox(height: 12),
                  _MountainRecommendationCard(),
                  SizedBox(height: 100), // Spasi aman agar tidak tertutup tombol di bawah
                ],
              ),
            ),
            const _FinishButtonSection(),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// PREMIUM DARK MODE SUB-WIDGETS (STATELESS CLASS)
// =========================================================

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Fitness Check',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Evaluate your readiness before hiking',
            style: TextStyle(
              color: Color(0xFFA1A1AA),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalScoreCard extends StatelessWidget {
  const _FinalScoreCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Stack(
        children: [
          // Efek Soft Glowing Hijau di Pojok Atas
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34C759).withOpacity(0.12),
                    blurRadius: 50,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Final Fitness Score',
                  style: TextStyle(
                    color: Color(0xFFE4E4E7),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '75',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 88,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF34C759).withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.directions_walk_rounded, color: Color(0xFF34C759), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Eligible for Medium Hiking',
                          style: TextStyle(
                            color: Color(0xFF34C759),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatsRow extends StatelessWidget {
  const _MiniStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatScoreCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.orange,
            score: '78',
            title: 'Training Score',
            topRightLabel: 'Out of 100',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatScoreCard(
            icon: Icons.monitor_weight_outlined,
            iconColor: Colors.blueAccent,
            score: '22.4',
            title: 'BMI Score',
            topRightLabel: 'Ideal',
            isBmi: true,
          ),
        ),
      ],
    );
  }
}

class _StatScoreCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String score;
  final String title;
  final String topRightLabel;
  final bool isBmi;

  const _StatScoreCard({
    required this.icon,
    required this.iconColor,
    required this.score,
    required this.title,
    required this.topRightLabel,
    this.isBmi = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isBmi ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  topRightLabel,
                  style: TextStyle(
                    color: isBmi ? Colors.blueAccent : const Color(0xFF71717A),
                    fontSize: 10,
                    fontWeight: isBmi ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            score,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Color(0xFF71717A), fontSize: 12)),
        ],
      ),
    );
  }
}

class _RecommendationHeader extends StatelessWidget {
  const _RecommendationHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recommended Mountains',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: const Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF34C759),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _MountainRecommendationCard extends StatelessWidget {
  const _MountainRecommendationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF27272A)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/gunung/prau.png', // Menggunakan jalur folder gunung terpadu
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              cacheWidth: 150, // Optimal memangkas RAM decode gambar ukuran kecil
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: const Color(0xFF27272A),
                child: const Icon(Icons.terrain_rounded, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mt. Prau',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.moving_rounded, color: Color(0xFF71717A), size: 12),
                    SizedBox(width: 4),
                    Text('2.5 km', style: TextStyle(color: Color(0xFF71717A), fontSize: 12)),
                    SizedBox(width: 8),
                    Text('•', style: TextStyle(color: Color(0xFF71717A), fontSize: 12)),
                    SizedBox(width: 8),
                    Icon(Icons.eco, color: Color(0xFF34C759), size: 12),
                    SizedBox(width: 4),
                    Text('Easy', style: TextStyle(color: Color(0xFF34C759), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
          )
        ],
      ),
    );
  }
}

class _FinishButtonSection extends StatelessWidget {
  const _FinishButtonSection();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6930), // Menggunakan Hijau HikingFit Konstan
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ),
              elevation: 0,
            ),
            onPressed: () {
              // Menghapus tumpukan history halaman dan kembali ke sirkulasi navigasi inti
              Get.offAllNamed('/main');
            },
            child: const Text(
              'Finish',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}