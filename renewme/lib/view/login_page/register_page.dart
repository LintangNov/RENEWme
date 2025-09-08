import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renewme/view/login_page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double get screenWidth => MediaQuery.of(context).size.width;

  double get screenHeight => MediaQuery.of(context).size.height;

  double get horizontalPadding => screenWidth * 0.1;

  double get verticalPadding => screenWidth * 0.1;

  @override
  Widget build(BuildContext context) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Back button
                          Padding(
                            padding: EdgeInsets.all(
                              horizontalPadding * 0.4,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_back_ios_new),
                              style: TextButton.styleFrom(
                                shape: CircleBorder(),
                                // backgroundColor: Colors.white,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          // Area form
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            width: screenWidth,
                            height: screenHeight * 0.85,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: verticalPadding ),

                                //Header
                                Container(
                                  height: screenHeight * 0.1,
                                  width: screenWidth,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Register',
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF53B675),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Silahkan buat akun baru',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: verticalPadding * 0.6),

                                // Nama
                                TextField(
                                  enableInteractiveSelection: true,
                                  decoration: InputDecoration(
                                    labelText: 'Nama',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      size: verticalPadding * 0.5,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.5,
                                      vertical: verticalPadding * 0.4,
                                    ),
                                  ),
                                ),

                                SizedBox(height: verticalPadding * 0.6),

                                // No ponsel
                                TextField(
                                  enableInteractiveSelection: true,
                                  decoration: InputDecoration(
                                    labelText: 'No Ponsel',
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      size: verticalPadding * 0.5,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.5,
                                      vertical: verticalPadding * 0.4,
                                    ),
                                  ),
                                ),

                                SizedBox(height: verticalPadding * 0.6),

                                // Email
                                TextField(
                                  enableInteractiveSelection: true,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      size: verticalPadding * 0.5,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.5,
                                      vertical: verticalPadding * 0.4,
                                    ),
                                  ),
                                ),

                                SizedBox(height: verticalPadding * 0.6),

                                //Password
                                TextField(
                                  enableInteractiveSelection: true,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      size: verticalPadding * 0.5,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.visibility,
                                        size: verticalPadding * 0.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding * 0.5,
                                      vertical: verticalPadding * 0.4,
                                    ),
                                  ),
                                ),

                                SizedBox(height: verticalPadding * 2),

                                SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.07,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF53B675),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: verticalPadding * 0.20),
                              ],
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
