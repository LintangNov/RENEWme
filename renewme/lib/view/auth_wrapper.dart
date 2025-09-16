import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/view/dashboard_page.dart';
import 'package:renewme/view/login_page/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    
    final UserController userController = Get.find<UserController>();

    
    return Obx(() {
    
      if (userController.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      
      if (userController.isLoggedIn()) {
       
        return const DashboardPage();
      } else {
        
        return const LoginPage();
      }
    });
  }
}