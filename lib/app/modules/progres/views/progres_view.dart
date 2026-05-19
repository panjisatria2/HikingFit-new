import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/progres/controllers/progres_controller.dart';

class ProgresView extends GetView<ProgresController> {
  const ProgresView({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _HeaderSection(),
                  SizedBox(height: 24),
                  _StatsCardSection(),
                  SizedBox(height: 32),
                  Text(
                    'Workout History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  _WorkoutHistorySection(),
                  SizedBox(height: 32),
                  _ChartHeaderSection(),
                  SizedBox(height: 16),
                  _ProgressChartCard(),
                  SizedBox(height: 100), // Jaga jarak napas dari navbar melayang
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// OPTIMIZED SUB-WIDGETS (CONVERTED TO COMPACT STATELESS)
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
          color: const Color(0xFF4A7C59).withOpacity(0.1),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Lacak & Tingkatkan 🌿',
              style: TextStyle(color: Color(0xFF6B906A), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Your Progress',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF2E5B2C), size: 20),
            ),
            const SizedBox(width: 12),
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF2E5B2C), size: 24),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatsCardSection extends StatelessWidget {
  const _StatsCardSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const _StatItem(icon: Icons.local_fire_department_rounded, color: Colors.orange, title: 'Streak', value: '0 Days'),
          Container(height: 40, width: 1, color: Colors.grey.shade200),
          _StatItem(icon: Icons.show_chart_rounded, color: Colors.green.shade400, title: 'Score', value: '0 pts'),
          Container(height: 40, width: 1, color: Colors.grey.shade200),
          _StatItem(icon: Icons.monitor_weight_outlined, color: Colors.blue.shade300, title: 'Last BMI', value: '24.5', isBmi: true),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final bool isBmi;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    this.isBmi = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isBmi ? const Color(0xFF2E5B2C) : Colors.black87,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _WorkoutHistorySection extends StatelessWidget {
  const _WorkoutHistorySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _HistoryCard(title: 'Trail Run', sub: 'Mon, 23 Jun • 0 km · 0 min', color: Colors.green, icon: Icons.directions_run),
        _HistoryCard(title: 'Strength Training', sub: 'Sat, 21 Jun • Gym · 0 min', color: Colors.orange, icon: Icons.fitness_center),
        _HistoryCard(title: 'Mountain Hike', sub: 'Thu, 19 Jun • 0 km · 0h 0m', color: Colors.blue, icon: Icons.terrain),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String sub;
  final Color color;
  final IconData icon;

  const _HistoryCard({
    required this.title,
    required this.sub,
    required this.color,
    required this.icon,
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sub, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              ],
            ),
          ),
          const Text('0 pts', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ChartHeaderSection extends StatelessWidget {
  const _ChartHeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Progress Chart',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(20)),
          child: Text(
            '6 Minggu',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade800),
          ),
        ),
      ],
    );
  }
}

class _ProgressChartCard extends StatelessWidget {
  const _ProgressChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/training/progrescard.png',
          fit: BoxFit.contain,
          // Membatasi lebar cache gambar di memori agar hemat memori RAM
          cacheWidth: 600,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180,
              color: Colors.grey.shade50,
              child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}