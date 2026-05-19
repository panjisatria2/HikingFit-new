class ApiEndpoints {
  // ========================================================
  // 1. BASE URL
  // Ganti IP ini sesuai dengan kondisi (10.0.2.2 untuk emulator,
  // atau IP WiFi laptop 192.168.x.x jika di-run ke HP fisik)
  // ========================================================
  static const String baseUrl = 'https://backend-hiking-fit.vercel.app/api';

  // ========================================================
  // 2. ENDPOINTS AUTHENTICATION & PROFILE
  // ========================================================
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String onboarding = '$baseUrl/auth/onboarding';
  static const String profile = '$baseUrl/auth/profile';

// Nanti kalau Abang nambah fitur gunung, tinggal tambahin di sini:
// static const String getAllGunung = '$baseUrl/gunung';
// static const String getDetailGunung = '$baseUrl/gunung/detail';
}