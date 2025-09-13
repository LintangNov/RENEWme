import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/view/dashboard_page.dart';
import 'package:renewme/view/login_page/login_page.dart'; // Sesuaikan path import

// 1. Ganti dari StatefulWidget menjadi StatelessWidget dan extends GetView<UserController>
// Ini cara best practice di GetX, kita tidak butuh StatefulWidget lagi.
class PersonalPage extends GetView<UserController> {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller bisa langsung diakses dengan 'controller', tidak perlu Get.find() lagi.
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            pinned: true,
            elevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 40, bottom: 14),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF5ABE79),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 2. Gunakan Obx untuk membuat UI menjadi reaktif
                  // Widget di dalam Obx akan otomatis di-build ulang saat
                  // variabel .obs di controller berubah.
                  Obx(() {
                    // Tampilkan loading indicator jika sedang fetching data
                    if (controller.isLoading.value &&
                        controller.currentUser.value == null) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }
                    // Tampilkan username jika data sudah ada, atau 'Guest' jika null
                    return SizedBox(
                      width: 150,
                      height: 20,
                      child: Text(
                        controller.currentUser.value?.username ?? 'Guest',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            expandedHeight: 120,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // --- KELOMPOK MENU ---
                // (Menu lainnya tetap sama, hanya onTap-nya saja yang bisa dihubungkan ke controller)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildListItem(
                        icon: Icons.person_2_outlined,
                        iconColor: Theme.of(context).colorScheme.primary,
                        title: 'Ubah Akun',
                        onTap: () => _showTapMessage('Ubah Akun'),
                      ),
                      _buildListItem(
                        icon: Icons.notifications_none,
                        iconColor: Theme.of(context).colorScheme.primary,
                        title: 'Notification',
                        onTap: () => _showTapMessage('Notification'),
                      ),
                      _buildListItem(
                        icon: Icons.location_on_outlined,
                        iconColor: Theme.of(context).colorScheme.primary,
                        title: 'Alamat',
                        onTap: () => _showTapMessage('Alamat'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      _buildListItem(
                        icon: Icons.help_outline_rounded,
                        iconColor: Theme.of(context).colorScheme.primary,
                        title: 'Pusat Bantuan',
                        onTap: () => _showTapMessage('Ubah Akun'),
                      ),
                      _buildListItem(
                        icon: Icons.info_outline_rounded,
                        iconColor: Theme.of(context).colorScheme.primary,
                        title: 'Informasi Aplikasi',
                        onTap: () => _showTapMessage('Notification'),
                      ),
                    ],
                  ),
                ),
                // (Sama seperti kode sebelumnya, aku singkat di sini agar fokus pada perubahan)
                const SizedBox(height: 10),

                // 3. Tambahkan tombol Logout dan hubungkan ke controller
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: _buildListItem(
                    icon: Icons.logout,
                    iconColor: Theme.of(context).colorScheme.primary,
                    title: 'Logout',
                    onTap: () {
                      Get.offAll(() => LoginPage());
                      // Panggil method signOut dari UserController
                      controller.signOut();
                      Get.snackbar('Berhasil', 'Anda telah keluar.');
                    },
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar tidak perlu diubah
    );
  }

  // Helper Widget tidak perlu diubah
  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (trailing != null) trailing,
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  void _showTapMessage(String message) {
    Get.snackbar(
      'Informasi',
      '$message di-tap!',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }
}
