import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/view/search_page/search_page.dart';

// Diubah menjadi StatelessWidget karena semua state dikelola oleh GetX.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Semua controller diambil di dalam build method.
    final FoodController foodController = Get.find<FoodController>();
    final UserController userController = Get.find<UserController>();

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        // RefreshIndicator untuk fitur "tarik untuk refresh".
        child: RefreshIndicator(
          onRefresh: () async {
            // Memuat ulang semua data saat ditarik.
            await userController.updateUserLocationAndAddress();
            await foodController.fetchAllFoods();
          },
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, screenHeight, horizontalPadding, userController),

              // Judul seksi "Promo Hari Ini"
              _buildSectionTitle(horizontalPadding, '🔥 Promo Hari Ini'),

              // Daftar makanan horizontal untuk promo
              Obx(() {
                if (foodController.isLoading.value && foodController.foodList.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                if (foodController.foodList.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                // Menampilkan 5 item pertama sebagai promo
                final promoItems = foodController.foodList.take(5).toList();
                return _buildHorizontalFoodList(promoItems);
              }),

              // Judul seksi "Rekomendasi"
              _buildSectionTitle(horizontalPadding, 'Rekomendasi Untukmu'),

              // Daftar makanan vertikal untuk semua item
              Obx(() {
                if (foodController.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (foodController.foodList.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('Belum ada makanan yang tersedia.'),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final food = foodController.foodList[index];
                      return _buildCardVertical(foodData: food);
                    },
                    childCount: foodController.foodList.length,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk SliverAppBar
  SliverAppBar _buildSliverAppBar(BuildContext context, double screenHeight, double horizontalPadding, UserController userController) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      expandedHeight: screenHeight * 0.25,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            SvgPicture.asset('assets/images/background.svg', fit: BoxFit.cover),
            Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding).copyWith(top: kToolbarHeight),
              // --- PERBAIKAN DI SINI ---
              // Menambahkan padding di bagian bawah untuk memberi ruang bagi search bar.
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0), // 60.0 adalah tinggi search bar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          // Menggunakan nama user jika ada, jika tidak tampilkan default
                          'Welcome, ${userController.currentUser.value?.username ?? 'Tamu'}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(height: 10),
                    const Text('Lokasi Anda saat ini:', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_pin, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() {
                            if (userController.isFetchingLocation.value || userController.isFetchingAddress.value) {
                              return Text('Mencari lokasi anda....',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              );
                            }
                            return Text(
                              userController.userAddress.value,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          }),
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: TextField(
            readOnly: true,
            onTap: () => Get.to(() => const SearchPage()),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Cari makanan...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk judul seksi
  SliverToBoxAdapter _buildSectionTitle(double horizontalPadding, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget helper untuk daftar makanan horizontal
  SliverToBoxAdapter _buildHorizontalFoodList(List<Food> foods) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: foods.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return _buildCardHorizontal(foodData: foods[index]);
          },
        ),
      ),
    );
  }
}

// --- WIDGET CARD (BISA DIPINDAH KE FILE TERPISAH) ---

Widget _buildCardVertical({required Food foodData}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: Colors.grey.shade100,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () { /* Navigasi ke detail page */ },
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: Image.network(
                    foodData.imageUrl ?? 'https://i.imgur.com/ew28hXp.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) => progress == null ? child : const SizedBox(height: 150, child: Center(child: CircularProgressIndicator())),
                    errorBuilder: (context, error, stack) => const SizedBox(height: 150, child: Icon(Icons.broken_image, color: Colors.grey, size: 48)),
                  ),
                ),
                Positioned(
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                    ),
                    child: Text('Sisa ${foodData.quantity}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodData.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(foodData.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [ const Icon(Icons.star, size: 20, color: Colors.orange), const SizedBox(width: 4), const Text('4.9', style: TextStyle(fontWeight: FontWeight.bold))]),
                      Text('Rp${foodData.priceInRupiah}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCardHorizontal({required Food foodData}) {
  return Container(
    width: 180,
    margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 2,
      shadowColor: Colors.grey.shade100,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () { /* Navigasi ke detail page */ },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Image.network(
                foodData.imageUrl ?? 'https://i.imgur.com/ew28hXp.png',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null ? child : const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                errorBuilder: (context, error, stack) => const SizedBox(height: 120, child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(foodData.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text('Rp${foodData.priceInRupiah}', style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green)),
            ),
          ],
        ),
      ),
    ),
  );
}

