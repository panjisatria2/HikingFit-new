import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/quesioner/controllers/quesioner_controller.dart';


class QuesionerView extends GetView<QuesionerController> {
  const QuesionerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _HeaderSection(),
                    SizedBox(height: 32),
                    _TitleSection(),
                    SizedBox(height: 32),
                    _HeightCardSection(),
                    SizedBox(height: 24),
                    _WeightCardSection(),
                    SizedBox(height: 24),
                    _ExperienceCardSection(),
                    SizedBox(height: 24),
                    _FitnessGoalsCardSection(),
                    SizedBox(height: 24),
                    _MountainPreferenceCardSection(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            const _BottomActionBar(),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// OPTIMIZED ONBOARDING SUB-WIDGETS (STATELESS CLASS)
// =========================================================

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: const Color(0xFFE8F5E9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2E6930), size: 18),
            ),
          ),
        ),
        Row(
          children: const [
            Icon(Icons.terrain_rounded, color: Color(0xFF2E6930), size: 28),
            SizedBox(width: 8),
            Text('HikingFit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E6930), letterSpacing: -0.5)),
          ],
        ),
        const Text('1/1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black38)),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Tell us about yourself', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A), height: 1.2, letterSpacing: -0.5)),
        SizedBox(height: 8),
        Text("We'll personalize your hiking and training experience.", style: TextStyle(fontSize: 15, color: Colors.black54)),
      ],
    );
  }
}

class _HeightCardSection extends GetView<QuesionerController> {
  const _HeightCardSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.straighten_rounded, color: Color(0xFF2E6930)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Height', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
                  Text('Centimeters', style: TextStyle(fontSize: 13, color: Colors.black45)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                child: Obx(() => RichText(
                  text: TextSpan(
                    text: '${controller.heightValue.value}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E6930)),
                    children: const [TextSpan(text: ' cm', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E6930)))],
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: const Color(0xFF2E6930),
              inactiveTrackColor: const Color(0xFFEFEFEF),
              thumbColor: const Color(0xFF2E6930),
              overlayColor: const Color(0xFF2E6930).withOpacity(0.2),
            ),
            child: Slider(
              value: controller.heightValue.value.toDouble(),
              min: 140,
              max: 220,
              onChanged: (value) => controller.heightValue.value = value.round(),
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('140 cm', style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
                Text('220 cm', style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightCardSection extends GetView<QuesionerController> {
  const _WeightCardSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFF2E6930)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
                  Text('Kilograms', style: TextStyle(fontSize: 13, color: Colors.black45)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
                child: Obx(() => RichText(
                  text: TextSpan(
                    text: '${controller.weightValue.value}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E6930)),
                    children: const [TextSpan(text: ' kg', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E6930)))],
                  ),
                )),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() => SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: const Color(0xFF2E6930),
              inactiveTrackColor: const Color(0xFFEFEFEF),
              thumbColor: const Color(0xFF2E6930),
            ),
            child: Slider(
              value: controller.weightValue.value.toDouble(),
              min: 40,
              max: 150,
              onChanged: (value) => controller.weightValue.value = value.round(),
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('40 kg', style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
                Text('150 kg', style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCardSection extends GetView<QuesionerController> {
  const _ExperienceCardSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildSelectionCard(
      title: 'Experience Level',
      subtitle: 'Select your hiking experience',
      icon: Icons.show_chart_rounded,
      options: controller.expOptions,
      selectedIndex: controller.expIndex.value,
      onSelect: controller.setExperience,
    ));
  }
}

class _FitnessGoalsCardSection extends GetView<QuesionerController> {
  const _FitnessGoalsCardSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildSelectionCard(
      title: 'Fitness Goals',
      subtitle: 'What do you want to achieve?',
      icon: Icons.flag_rounded,
      options: controller.goalOptions,
      selectedIndex: controller.goalIndex.value,
      onSelect: controller.setGoal,
    ));
  }
}

class _MountainPreferenceCardSection extends GetView<QuesionerController> {
  const _MountainPreferenceCardSection();

  @override
  Widget build(BuildContext context) {
    return Obx(() => _buildSelectionCard(
      title: 'Mountain Preference',
      subtitle: 'Your preferred trail difficulty',
      icon: Icons.filter_hdr_rounded,
      options: controller.mountOptions,
      selectedIndex: controller.mountIndex.value,
      onSelect: controller.setMountain,
    ));
  }
}

// Helper Widget Terisolasi untuk List Tombol Pilihan
Widget _buildSelectionCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required List<String> options,
  required int selectedIndex,
  required Function(int) onSelect,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF2E6930)),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A))),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black45)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(options.length, (index) {
            bool isActive = index == selectedIndex;
            return GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2E6930) : const Color(0xFFF9FBFA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isActive ? const Color(0xFF2E6930) : const Color(0xFFEFEFEF)),
                ),
                child: Text(
                  options[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black87,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );
}

class _BottomActionBar extends GetView<QuesionerController> {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shield_outlined, color: Colors.black45, size: 16),
              SizedBox(width: 8),
              Text('Your data is private and secure', style: TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6930),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: controller.isLoading.value ? null : () => controller.submitOnboarding(),
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.directions_walk_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Complete Profile', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}