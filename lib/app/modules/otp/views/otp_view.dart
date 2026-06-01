import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart'; // Sesuaikan path import-nya

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A7C59);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Ilustrasi Icon yang lebih modern dengan Background Lingkaran Halus
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                    Icons.mark_email_unread_rounded,
                    size: 64,
                    color: primaryColor
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Verifikasi Email Anda',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5
                ),
              ),
              const SizedBox(height: 12),

              // Text deskripsi dengan highlight pada email user
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                  children: [
                    const TextSpan(text: 'Kami telah mengirimkan 6 digit kode OTP ke email:\n'),
                    TextSpan(
                      text: controller.email,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Box Input OTP yang lebih profesional (Menggunakan Pinput-like style secara native)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 48,
                    child: TextField(
                      controller: controller.otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(
                          fontSize: 28,
                          letterSpacing: 18.0,
                          fontWeight: FontWeight.bold,
                          color: primaryColor
                      ),
                      decoration: InputDecoration(
                        counterText: '', // Menghilangkan counter length di bawah
                        hintText: '000000',
                        hintStyle: TextStyle(color: Colors.grey.shade300, letterSpacing: 18.0),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Tombol Submit yang Reaktif dengan Loading
              Obx(() {
                final isLoading = controller.isLoading.value;
                return SizedBox(
                  width: double.infinity,
                  height: 56, // Sedikit lebih tebal agar lebih premium
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      elevation: 2,
                      shadowColor: primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isLoading ? null : () => controller.verifyOtp(),
                    child: isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Text(
                      'Verifikasi',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Tambahan Opsional: Tombol Kirim Ulang OTP (UX Terbaik)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Tidak menerima kode? ", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  TextButton(
                    onPressed: () {
                      // Tambahkan logika kirim ulang jika ada di controller
                      // controller.resendOtp();
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      "Kirim Ulang",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}