import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'api_endpoints.dart';

class ApiService {
  // =========================================================
  // MESIN OTOMATIS PENCETAK TOKEN FRESH (ANTI KADALUARSA)
  // =========================================================
  static Future<String?> _getFreshToken() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    // KEAJAIBAN FIREBASE ADA DI SINI:
    // Jika token masih hidup, dia akan mengembalikan token lama.
    // TAPI jika token sudah mati (lewat 1 jam), Firebase akan OTOMATIS
    // request ke server Google untuk minta token baru, lalu mengembalikannya.
    return await currentUser.getIdToken();
  }

  // =========================================================
  // TEMPLATE UNTUK GET REQUEST
  // =========================================================
  static Future<http.Response> get(String endpoint) async {
    String? token = await _getFreshToken();

    return await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // =========================================================
  // TEMPLATE UNTUK POST REQUEST
  // =========================================================
  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    String? token = await _getFreshToken();

    return await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  // =========================================================
  // TEMPLATE UNTUK PUT REQUEST (Sering dipakai untuk Update Profil)
  // =========================================================
  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    String? token = await _getFreshToken();

    return await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}