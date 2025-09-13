import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renewme/view/login_page/register_page.dart';
import 'package:renewme/controllers/user_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Buat GlobalKey untuk Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Pindahkan semua controller ke dalam build method
    final UserController userController = Get.find<UserController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Variabel ukuran layar
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.1;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            SizedBox.expand(
              child: SvgPicture.asset(
                'assets/images/background.svg',
                fit: BoxFit.cover,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Header
                          Container(
                            width: screenWidth,
                            height: screenHeight * 0.25,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Selamat Datang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'Silakan login terlebih dahulu',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Area form
                          Container(
                            height: screenHeight * 0.6,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: horizontalPadding,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: horizontalPadding * 0.5,
                                        vertical: horizontalPadding * 0.5,
                                      ),
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    keyboardType: TextInputType.emailAddress,

                                    validator: (value) {
                                      if (value == null ||
                                          !GetUtils.isEmail(value)) {
                                        return 'Format email tidak valid';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.03),
                                  Obx(
                                    () => TextFormField(
                                      enableInteractiveSelection: true,

                                      controller: passwordController,
                                      obscureText:
                                          userController.isHidePassword.value,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: horizontalPadding * 0.5,
                                          vertical: horizontalPadding * 0.5,
                                        ),
                                        labelText: 'Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            userController.isHidePassword.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed:
                                              userController
                                                  .changePasswordVisibility,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  Obx(() {
                                    if (userController
                                        .errorMessage
                                        .isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 16.0,
                                        ),
                                        child: Text(
                                          userController.errorMessage.value,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                                  SizedBox(height: screenHeight * 0.05),
                                  SizedBox(
                                    width: double.infinity,
                                    height: screenHeight * 0.07,
                                    child: Obx(
                                      () => ElevatedButton(
                                        onPressed:
                                            userController.isLoading.value
                                                ? null
                                                : () async {
                                                  userController
                                                      .errorMessage
                                                      .value = '';
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    await userController.signIn(
                                                      email:
                                                          emailController.text,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    );
                                                  }
                                                },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF53B675,
                                          ),
                                        ),
                                        child:
                                            userController.isLoading.value
                                                ? const CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                                : const Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Belum punya akun?'),
                                      TextButton(
                                        onPressed:
                                            () => Get.to(
                                              () => const RegisterPage(),
                                            ),
                                        child: const Text(
                                          'Register',
                                          style: TextStyle(
                                            color: Color(0xFF53B675),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
