import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renewme/view/login_page/register_page.dart';
import 'package:renewme/controllers/user_controller.dart';

// 1. Ubah menjadi StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 2. Pindahkan semua controller dan key ke sini (State)
  final UserController userController = Get.find<UserController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // 3. Tambahkan dispose untuk membersihkan controller
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: SvgPicture.asset('assets/images/background.svg', fit: BoxFit.cover,),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                          // Backgorund
                          Container(
                          width: screenWidth,
                          height: 140,
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
                          padding: EdgeInsets.all(horizontalPadding),
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
                              children: [
                                TextFormField(
                                  // enableInteractiveSelection: true,
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Email', 
                                    prefixIcon: Icon(Icons.email), 
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || !GetUtils.isEmail(value)) return 'Format email tidak valid';
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                Obx(() => TextFormField(
                                      controller: passwordController,
                                      obscureText: userController.isHidePassword.value,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: const Icon(Icons.lock),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(userController.isHidePassword.value ? Icons.visibility_off : Icons.visibility),
                                          onPressed: userController.changePasswordVisibility,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
                                        return null;
                                      },
                                    ),
                                  ),
                                Obx(() {
                                  if (userController.errorMessage.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Text(userController.errorMessage.value, 
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.red, 
                                        fontWeight: FontWeight.bold),
                                      ), 
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                                SizedBox(height: screenHeight * 0.05),
                                SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.07,
                                  child: Obx(() => ElevatedButton(
                                        onPressed: userController.isLoading.value ? null : () async {
                                          userController.errorMessage.value = '';
                                          if (formKey.currentState!.validate()) {
                                            await userController.signIn(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF53B675)),
                                        child: userController.isLoading.value
                                            ? const CircularProgressIndicator(color: Colors.white)
                                            : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Belum punya akun?'),
                                    TextButton(
                                      onPressed: () => Get.to(() => const RegisterPage()),
                                      child: const Text('Register', style: TextStyle(color: Color(0xFF53B675), fontWeight: FontWeight.bold)),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}