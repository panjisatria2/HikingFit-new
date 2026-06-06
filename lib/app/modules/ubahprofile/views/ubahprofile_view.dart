import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ubahprofile_controller.dart';

class UbahprofileView extends GetView<UbahprofileController> {
  const UbahprofileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D1A), size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFF1A1D1A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const _AvatarPickerSection(),
            const SizedBox(height: 32),
            _CustomInputField(
              label: 'Full Name',
              hint: 'Masukkan nama lengkap',
              icon: Icons.person_outline_rounded,
              textController: controller.fullNameController,
            ),
            const SizedBox(height: 16),
            _CustomInputField(
              label: 'Email Address',
              hint: 'Email',
              icon: Icons.mail_outline_rounded,
              textController: controller.emailController,
              isEnabled: false, // Email tetap read-only
            ),
            const SizedBox(height: 16),
            const _BodyMetricsRow(),
            const SizedBox(height: 16),
            const _DemographicsRow(),
            const SizedBox(height: 32),
            const _BmiScoreCardSection(),
            const SizedBox(height: 40),
            const _ActionButtonsSection(),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// OPTIMIZED PROFILE SUB-WIDGETS (STATELESS CLASS)
// =========================================================

class _AvatarPickerSection extends GetView<UbahprofileController> {
  const _AvatarPickerSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Obx(() {
            Widget imageContent;
            final String imgData = controller.existingImageUrl.value;

            // 1. Jika ada file lokal yang baru dipilih dari kamera/galeri
            if (controller.imageFile.value != null) {
              imageContent = ClipOval(
                child: Image.file(
                  controller.imageFile.value!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            }
            // 2. Jika ada foto dari database (Base64 atau URL lama)
            else if (imgData.isNotEmpty) {
              imageContent = ClipOval(
                child: imgData.startsWith('data:image')
                    ? Image.memory(
                  base64Decode(imgData.split(',')[1]), // Decode teks Base64
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person_rounded, size: 54, color: Colors.white),
                )
                    : Image.network(
                  imgData, // Jaga-jaga kalau ada sisa URL lawas
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person_rounded, size: 54, color: Colors.white),
                ),
              );
            }
            // 3. Jika belum punya foto sama sekali
            else {
              imageContent = const Icon(Icons.person_rounded, size: 54, color: Colors.white);
            }

            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: imageContent,
            );
          }),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.showImagePickerOptions(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6930),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyMetricsRow extends GetView<UbahprofileController> {
  const _BodyMetricsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CustomInputField(
            label: 'Weight (BB)',
            hint: '0',
            icon: Icons.scale_rounded,
            suffixText: 'kg',
            keyboardType: TextInputType.number,
            textController: controller.weightController,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _CustomInputField(
            label: 'Height (TB)',
            hint: '0',
            icon: Icons.height_rounded,
            suffixText: 'cm',
            keyboardType: TextInputType.number,
            textController: controller.heightController,
          ),
        ),
      ],
    );
  }
}

class _DemographicsRow extends GetView<UbahprofileController> {
  const _DemographicsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CustomInputField(
            label: 'Age',
            hint: '0',
            icon: Icons.calendar_today_rounded,
            suffixText: 'yrs',
            keyboardType: TextInputType.number,
            textController: controller.ageController, // <--- Sambungkan Controller Umur
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _CustomDropdownField(
            label: 'Gender',
            icon: Icons.wc_rounded,
          ),
        ),
      ],
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isEnabled;
  final String? suffixText;
  final TextInputType keyboardType;
  final TextEditingController? textController;

  const _CustomInputField({
    required this.label,
    required this.hint,
    required this.icon,
    this.isEnabled = true,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          enabled: isEnabled,
          keyboardType: keyboardType,
          style: TextStyle(color: isEnabled ? const Color(0xFF1A1D1A) : Colors.black38, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: isEnabled ? const Color(0xFF2E6930) : Colors.black26, size: 20),
            suffixText: suffixText,
            suffixStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.bold, fontSize: 12),
            filled: true,
            fillColor: isEnabled ? Colors.white : const Color(0xFFF1F3F1),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF2E6930), width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEFEFEF)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomDropdownField extends GetView<UbahprofileController> {
  final String label;
  final IconData icon;

  const _CustomDropdownField({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A1D1A)),
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
          // Tampilkan nilai reaktif dari controller secara aman
          value: controller.selectedGender.value.isNotEmpty ? controller.selectedGender.value : null,
          style: const TextStyle(color: Color(0xFF1A1D1A), fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF2E6930), size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFEFEFEF))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF2E6930), width: 1.5)),
          ),
          items: const [
            DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
            DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
          ],
          onChanged: (value) => controller.changeGender(value), // <--- Panggil fungsi ubah gender
          hint: const Text('Pilih', style: TextStyle(color: Colors.grey, fontSize: 14)),
        )),
      ],
    );
  }
}

class _BmiScoreCardSection extends StatelessWidget {
  const _BmiScoreCardSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4E8D51), Color(0xFF2E6930)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2E6930).withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your BMI Score', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: const [
                  Text('22.4', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Text('Ideal', style: TextStyle(color: Color(0xFFB9F6CA), fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.monitor_weight_outlined, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonsSection extends GetView<UbahprofileController> {
  const _ActionButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(() => ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6930),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
            child: controller.isLoading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            )
                : const Text('Simpan Perubahan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          )),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEFEFEF)),
              foregroundColor: Colors.black54,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Get.back(),
            child: const Text('Kembali', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}