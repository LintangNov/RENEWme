import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  double get horizontalPadding => screenWidth * 0.1;
  double get verticalPadding => screenWidth * 0.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F0EA),
      body: SafeArea(
        top: false,
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight * 0.25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: SizedBox(
                        child: SvgPicture.asset(
                          'assets/images/background.svg',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        //Greeting Text
                        const Text(
                          'Hello, User!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: verticalPadding * 0.2),
                        //Location Title
                        const Text(
                          'Anter saat ini:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        // Geo Map Location
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     TextButton.icon(
                        //       onPressed: () {},
                        //       icon: Icon(Icons.location_pin, color: Colors.red),
                        //       label: const Text(
                        //         'Lokasimu',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        SizedBox(height: verticalPadding * 0.5),

                        // SliverAppBar(
                        //   backgroundColor: Colors.white,
                        //   actions: [
                        //     TextField(
                        //       decoration: InputDecoration(
                        //         filled: true,
                        //         fillColor: Colors.white,
                        //         disabledBorder: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(15),
                        //         ),
                        //         hintText: 'Mau makan apa ',
                        //         prefixIcon: Icon(Icons.search),
                        //         border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(15),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation tap 
        },
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'Pesanan saya',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
