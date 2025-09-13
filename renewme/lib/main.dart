import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/repositories/food_repository.dart';
import 'package:renewme/services/location_services.dart';
import 'package:renewme/view/dashboard_page.dart';
import 'package:renewme/view/login_page/login_page.dart';
import 'package:renewme/view/personal_page/personal_page.dart';
// import 'package:renewme/view/home_page/home_page.dart';
// import 'package:renewme/view/login_page/login_page.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:renewme/services/auth_services.dart';
import 'package:renewme/services/firestore_services.dart';
import 'package:renewme/repositories/user_repository.dart';
import 'package:renewme/controllers/user_controller.dart';

Future<void> initDependencies() async {
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => FirestoreService());
  Get.lazyPut(() => LocationService());

  Get.lazyPut(() => UserRepository(Get.find(), Get.find()));
  Get.lazyPut(() => FoodRepository(Get.find()));

  Get.put(UserController());
  Get.lazyPut(() => FoodController());
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
          secondaryContainer: Color(0xFFDFF1DB),
          secondary: Color(0xFFE5F0EA),
        ),
      ),
      home: LoginPage(),
    );
  }
}
