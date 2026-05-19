import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikingfit/app/modules/ubahpassword/controllers/ubahpassword_controller.dart';


class UbahpasswordView extends GetView<UbahpasswordController> {
  const UbahpasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFA), // Clean background khas modern UI
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1D1A), size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Color(0xFF1A1D1A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 16),
            _LockHeaderSection(),
            SizedBox(height: 40),
            _CustomPasswordField(
              label: 'Current Password',
              hint: 'Enter current password',
            ),
            SizedBox(height: 20),
            _CustomPasswordField(
              label: 'New Password',
              hint: 'Enter new password',
            ),
            SizedBox(height: 12),
            _PasswordRequirementsBox(),
            SizedBox(height: 20),
            _CustomPasswordField(
              label: 'Confirm New Password',
              hint: 'Re-enter new password',
            ),
            SizedBox(height: 40),
            _ActionButtonsSection(),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// OPTIMIZED PASSWORD SUB-WIDGETS (STATELESS CLASS)
// =========================================================

class _LockHeaderSection extends StatelessWidget {
  const _LockHeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9), // Hijau pudar khas tema
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E6930).withOpacity(0.06),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            size: 64,
            color: Color(0xFF2E6930),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Create New Password',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1D1A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Your new password must be different from previous used passwords.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomPasswordField extends StatelessWidget {
  final String label;
  final String hint;

  const _CustomPasswordField({required this.label, required this.hint});

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
          obscureText: true, // Proteksi input teks sandi
          style: const TextStyle(color: Color(0xFF1A1D1A), fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF2E6930), size: 20),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility_off_outlined, color: Colors.grey.shade400, size: 20),
              onPressed: () {
                // Catatan: Nanti kalau sudah pasang controller, logika hide/show ditaruh di sini ya Bang
              },
            ),
            filled: true,
            fillColor: Colors.white,
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
          ),
        ),
      ],
    );
  }
}

class _PasswordRequirementsBox extends StatelessWidget {
  const _PasswordRequirementsBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _RequirementRow(text: 'Minimum 8 characters'),
          SizedBox(height: 8),
          _RequirementRow(text: 'Must include a number or symbol'),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String text;
  const _RequirementRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline_rounded, size: 16, color: Colors.black38),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  const _ActionButtonsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6930),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: () {
              // Menghapus tumpukan history halaman lama dan kembali ke tab Settings (Index 3)
              Get.offAllNamed('/main', arguments: 3);
              Get.snackbar(
                'Success',
                'Password berhasil diubah!',
                backgroundColor: const Color(0xFF2E6930),
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP, // Dipindahkan ke top agar seimbang dengan edit profil
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
                icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              );
            },
            child: const Text('Update Password', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
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
            child: const Text('Batal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}