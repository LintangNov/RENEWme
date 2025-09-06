// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double get screenWidth => MediaQuery.of(context).size.width;

  double get screenHeight => MediaQuery.of(context).size.height;

  double get horizontalPadding => screenWidth * 0.1;

  double get verticalPadding => screenWidth * 0.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Sambutan
          Container(
            width: screenWidth,
            height: screenHeight * 0.12,
            padding: EdgeInsets.only(left: screenWidth * 0.1),
            child: Text(
              'Selamat Datang, ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
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
              vertical: verticalPadding,
            ),
            height: screenHeight * 0.75,
            width: screenWidth,
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth - (horizontalPadding * 2),
                  ),
                  child: Column(
                    children: [
                      Text('Silahkan masukkan akun anda'),
                      SizedBox(height: verticalPadding),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding * 0.5,
                            vertical: verticalPadding * 0.5,
                          ),
                        ),
                      ),

                      SizedBox(height: verticalPadding * 0.8),

                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility_outlined)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding * 0.5,
                            vertical: verticalPadding * 0.5,
                          ),
                        ),
                      ),

                      // Lupa Sandi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Lupa Sandi?',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: verticalPadding * 2),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: verticalPadding * 0.20),

                      // Footer text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
