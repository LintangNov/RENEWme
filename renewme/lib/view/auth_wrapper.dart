import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/view/dashboard_page.dart';
import 'package:renewme/view/login_page/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil instance UserController
    final UserController userController = Get.find<UserController>();

    // Obx akan "mendengarkan" perubahan pada currentUser dan isLoading
    return Obx(() {
      // Selama proses pengecekan awal, tampilkan layar loading
      if (userController.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Setelah selesai, cek apakah ada pengguna yang login
      if (userController.isLoggedIn()) {
        // Jika ya, langsung arahkan ke DashboardPage
        return const DashboardPage();
      } else {
        // Jika tidak, arahkan ke LoginPage
        return const LoginPage();
      }
    });
  }
}