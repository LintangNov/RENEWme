import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/navigation_controller.dart';


import 'package:renewme/view/home_page/home_page.dart';
import 'package:renewme/view/search_page/search_page.dart';
import 'package:renewme/view/add_item_page/add_food_form.dart';
import 'package:renewme/view/history_page/history_page.dart';
import 'package:renewme/view/personal_page/personal_page.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    final NavigationController navController = Get.put(NavigationController());

    // urutan daftar halaman
    final List<Widget> pages = [
      const HomePage(),
      const SearchPage(),
      const AddFoodPage(),
      const HistoryPage(),
      const PersonalPage(),
    ];

    return Scaffold(

      body: Obx(
        () => IndexedStack(
          index: navController.tabIndex.value,
          children: pages,
        ),
      ),

      
      // item yang aktif (highlight) sesuai dengan tabIndex.
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          // currentIndex terhubung ke tabIndex untuk menyorot item yang benar.
          currentIndex: navController.tabIndex.value,
          onTap: navController.changeTabIndex,
          
          // Properti UI untuk styling.
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).colorScheme.primary, // Warna item aktif
          unselectedItemColor: Colors.grey, // Warna item non-aktif
          type: BottomNavigationBarType.fixed, // Agar semua label terlihat
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),

          // Daftar item navigasi.
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                navController.tabIndex.value == 0 ? Icons.home_filled:Icons.home_outlined,
                ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                navController.tabIndex.value == 1 ? Icons.search:Icons.search_outlined,
              ),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                navController.tabIndex.value == 2 ? Icons.add_box:Icons.add_box_outlined,
              ),
              label: 'Tambah',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                navController.tabIndex.value == 3 ? Icons.history:Icons.history_outlined
                ),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                navController.tabIndex.value == 4 ? Icons.person:Icons.person_outlined,
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}