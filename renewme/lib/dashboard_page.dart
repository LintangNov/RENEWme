import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/navigation_controller.dart';

// Import semua halaman yang akan Anda gunakan dalam navigasi.
// Pastikan path-nya sesuai dengan struktur proyek Anda.
import 'package:renewme/view/home_page/home_page.dart';
import 'package:renewme/view/search_page/search_page.dart';
import 'package:renewme/view/add_item_page/add_food_form.dart';
import 'package:renewme/view/history_page/history_page.dart';
import 'package:renewme/view/personal_page/personal_page.dart';

/// DashboardPage adalah widget utama yang menjadi "rumah" bagi BottomNavigationBar.
/// Ia tidak memiliki state sendiri (StatelessWidget) karena statenya dikelola oleh NavigationController.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi NavigationController menggunakan Get.put().
    // Ini membuat controller tersedia untuk semua widget anak di bawah DashboardPage.
    final NavigationController navController = Get.put(NavigationController());

    // Daftar halaman yang akan ditampilkan, urutannya HARUS SAMA
    // dengan urutan item di BottomNavigationBar.
    final List<Widget> pages = [
      const HomePage(),
      const SearchPage(),
      const AddFoodPage(),
      const HistoryPage(),
      const PersonalPage(),
    ];

    return Scaffold(
      // Properti body dibungkus dengan Obx agar dapat bereaksi terhadap
      // perubahan tabIndex di dalam NavigationController.
      body: Obx(
        () => IndexedStack(
          // index dari IndexedStack terhubung langsung dengan nilai tabIndex.
          index: navController.tabIndex.value,
          // children adalah daftar halaman yang sudah kita siapkan.
          children: pages,
        ),
      ),

      // BottomNavigationBar juga dibungkus dengan Obx untuk memastikan
      // item yang aktif (highlight) sesuai dengan tabIndex.
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          // currentIndex terhubung ke tabIndex untuk menyorot item yang benar.
          currentIndex: navController.tabIndex.value,
          // onTap memanggil method di controller untuk mengubah tabIndex.
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'Tambah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}