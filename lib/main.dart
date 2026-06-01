import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // <-- 1. Import Firebase
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async { // <-- 2. Tambahkan 'async' di sini
  // 3. Wajib ditambahkan sebelum inisialisasi Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Menyalakan mesin Firebase
  await Firebase.initializeApp();

  runApp(
    GetMaterialApp(
      title: "HikingFit", // Bisa diganti sesuai nama aplikasi
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false, // Menghilangkan pita merah "DEBUG" di pojok kanan atas
    ),
  );
}