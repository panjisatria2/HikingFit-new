import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/listgunung/controllers/listgunung_controller.dart';

class ListgunungView extends GetView<ListgunungController> {
  const ListgunungView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeaderSection(),
            SizedBox(height: 24),
            _SearchBarSection(),
            SizedBox(height: 20),
            _FilterChipsSection(),
            SizedBox(height: 24),
            _InfoBarSection(),
            SizedBox(height: 16),
            _MountainListSection(),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// OPTIMIZED SUB-WIDGETS (CONVERTED TO COMPACT STATELESS)
// =========================================================

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            shadowColor: Colors.black.withOpacity(0.1),
            elevation: 4,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Jelajahi & Taklukkan ',
                      style: TextStyle(
                        color: Color(0xFF4A7C59),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Icon(Icons.eco, color: Color(0xFF4A7C59), size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pilih Gunung',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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

class _SearchBarSection extends StatelessWidget {
  const _SearchBarSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Cari pegunungan...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}

class _FilterChipsSection extends StatelessWidget {
  const _FilterChipsSection();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: const [
          _FilterChip(label: 'All', isSelected: true),
          _DifficultyChip(label: 'Light', color: Color(0xFF2ECC71)),
          _DifficultyChip(label: 'Medium', color: Color(0xFFF1C40F)),
          _DifficultyChip(label: 'Hard', color: Color(0xFFE74C3C)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2E5B2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade600,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final String label;
  final Color color;

  const _DifficultyChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBarSection extends StatelessWidget {
  const _InfoBarSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '2 Pegunungan Ditemukan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Row(
            children: const [
              Icon(Icons.sort_rounded, size: 18, color: Color(0xFF4A7C59)),
              SizedBox(width: 4),
              Text(
                'Sort by',
                style: TextStyle(
                  color: Color(0xFF4A7C59),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MountainListSection extends StatelessWidget {
  const _MountainListSection();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: const [
          _MountainCard(
            name: 'Gunung Prau',
            location: 'Dieng, Jawa Tengah',
            image: 'assets/gunung/prau.png',
            difficulty: 'Light',
            diffColor: Color(0xFF2ECC71),
            duration: '4h 30m',
            distance: '8.5 km',
            temp: '22°C',
          ),
          _MountainCard(
            name: 'Gunung Merbabu',
            location: 'Boyolali, Jawa Tengah',
            image: 'assets/gunung/merbabu.png',
            difficulty: 'Medium',
            diffColor: Color(0xFFF1C40F),
            duration: '7h 00m',
            distance: '12.3 km',
            temp: '22°C',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MountainCard extends StatelessWidget {
  final String name;
  final String location;
  final String image;
  final String difficulty;
  final Color diffColor;
  final String duration;
  final String distance;
  final String temp;

  const _MountainCard({
    required this.name,
    required this.location,
    required this.image,
    required this.difficulty,
    required this.diffColor,
    required this.duration,
    required this.distance,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/detailgunung'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Image.asset(
                    image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    cacheWidth: 500, // Mengurangi beban RAM saat decode gambar aset gunung
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.white, size: 50),
                    ),
                  ),
                ),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: diffColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.white, size: 8),
                        const SizedBox(width: 6),
                        Text(
                          difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoIconDetail(icon: Icons.access_time_filled, label: duration),
                  _InfoIconDetail(icon: Icons.moving_rounded, label: distance),
                  _InfoIconDetail(icon: Icons.cloud_rounded, label: temp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoIconDetail extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoIconDetail({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF4A7C59).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF4A7C59)),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}