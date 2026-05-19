import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart'; // Pastikan path ini sesuai dengan folder Abang

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 320.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // --- 1. SEKSI HEADER ---
            SizedBox(
              height: headerHeight,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: headerHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/gambar/Loginbg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: headerHeight,
                    decoration: BoxDecoration(
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
                  const _LogoAndTitleSection(),
                ],
              ),
            ),

            // --- 2. SEKSI FORM KARTU PUTIH ---
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sign in to continue your journey',
                      style: TextStyle(fontSize: 14, color: Colors.black38),
                    ),
                    const SizedBox(height: 28),

                    // --- INPUT EMAIL & PASSWORD ---
                    _CustomLoginInputField(
                      hint: 'Email Address',
                      icon: Icons.mail_outline_rounded,
                      textController: controller.emailController,
                    ),
                    const SizedBox(height: 16),
                    _CustomLoginInputField(
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      textController: controller.passwordController,
                    ),
                    const SizedBox(height: 28),

                    // --- TOMBOL LOGIN ---
                    const _LoginButtonAction(),

                    const SizedBox(height: 28),
                    const _DividerSection(),
                    const SizedBox(height: 28),
                    const _GoogleButtonAction(),
                    const SizedBox(height: 28),
                    const _RegisterLinkSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// OPTIMIZED LOGIN SUB-WIDGETS (STATELESS CLASS)
// =========================================================

class _LogoAndTitleSection extends StatelessWidget {
  const _LogoAndTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              'assets/gambar/logo.png',
              fit: BoxFit.contain,
              cacheWidth: 120,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.terrain_rounded, color: Color(0xFF2E6930), size: 36),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'HikingFit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'PREPARE FOR THE PEAK',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomLoginInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController textController;

  const _CustomLoginInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.textController,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1D1A)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FBFA),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF2E6930).withOpacity(0.4), size: 20),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(Icons.visibility_off_outlined, color: Colors.grey.shade400, size: 20),
          onPressed: () {
            // TODO: Toggle visibility password
          },
        )
            : null,
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
    );
  }
}

class _LoginButtonAction extends GetView<LoginController> {
  const _LoginButtonAction({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Obx(() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E6930),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        onPressed: controller.isLoading.value
            ? null
            : () => controller.loginUser(),
        child: controller.isLoading.value
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      )),
    );
  }
}

class _DividerSection extends StatelessWidget {
  const _DividerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
      ],
    );
  }
}

class _GoogleButtonAction extends StatelessWidget {
  const _GoogleButtonAction({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFEFEFEF)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gambar/Google.png',
              width: 22,
              cacheWidth: 50,
              errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text(
              'Google',
              style: TextStyle(color: Color(0xFF1A1D1A), fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterLinkSection extends StatelessWidget {
  const _RegisterLinkSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Get.toNamed('/register'),
        child: RichText(
          text: const TextSpan(
            text: "Don't have an account yet? ",
            style: TextStyle(color: Colors.black38, fontSize: 14),
            children: [
              TextSpan(
                text: 'Register',
                style: TextStyle(
                  color: Color(0xFF2E6930),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}