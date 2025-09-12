import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renewme/view/login_page/login_page.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:renewme/services/auth_services.dart';
import 'package:renewme/services/firestore_services.dart';
import 'package:renewme/repositories/user_repository.dart';
import 'package:renewme/controllers/user_controller.dart'; 

Future<void> initDependencies() async {
  // 1. Daftarkan service-mu terlebih dahulu.
  // Kita pakai lazyPut agar hanya dibuat saat pertama kali dibutuhkan (lebih efisien)
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => FirestoreService());

  // 2. Daftarkan repository-mu.
  // Saat UserRepository dibuat, GetX akan otomatis mencari service yang sudah terdaftar.
  Get.lazyPut(() => UserRepository(Get.find(), Get.find()));

  // 3. Daftarkan controller utama yang akan sering dipakai.
  // Kita pakai 'put' biasa agar langsung tersedia.
  Get.put(UserController());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initDependencies(); // Inisialisasi semua dependency sebelum runApp  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RenewMe',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5ABE79),
        ).copyWith(
          primary: Color(0xFF5ABE79),
          secondaryContainer: Color(0xFFDFF1DB),),

      ),
      home: const LoginPage(),
    );
  }
}
