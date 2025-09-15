import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/models/user.dart';
import 'package:renewme/utils/date_helper.dart';
import 'package:renewme/utils/location_helper.dart';
import 'package:renewme/view/search_page/search_page.dart';

// 1. Diubah menjadi StatelessWidget untuk efisiensi dan best practice.
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
            await userController.updateUserLocationAndAddress();
            await foodController.fetchAllFoods();
          },
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, screenHeight, horizontalPadding, userController),
              _buildSectionTitle(horizontalPadding, '🔥 Promo Hari Ini'),
              _buildHorizontalPromoList(foodController),
              _buildSectionTitle(horizontalPadding, 'Rekomendasi Untukmu'),
              _buildVerticalFoodList(foodController),
            ],
          ),
        ),
      ),
    );
  }

  // Bagian-bagian UI dipecah menjadi method helper agar lebih rapi.
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0), // Ruang untuk search bar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          'Selamat Datang, ${userController.currentUser.value?.username ?? 'Tamu'}',
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
                              return Row(
                                children: [
                                  const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                                  const SizedBox(width: 8),
                                  Text('Mencari lokasi...', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                ],
                              );
                            }
                            return Text(
                              userController.userAddress.value,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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

  SliverToBoxAdapter _buildSectionTitle(double horizontalPadding, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 8),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHorizontalPromoList(FoodController foodController) {
    return Obx(() {
      if (foodController.isLoading.value && foodController.foodList.isEmpty) {
        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
      }
      if (foodController.foodList.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }
      final promoItems = foodController.foodList.take(5).toList();
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: promoItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => _buildCardHorizontal(foodData: promoItems[index]),
          ),
        ),
      );
    });
  }

  Widget _buildVerticalFoodList(FoodController foodController) {
    return Obx(() {
      if (foodController.isLoading.value && foodController.foodList.isEmpty) {
        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
      }
      if (foodController.foodList.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(child: Padding(padding: EdgeInsets.all(40.0), child: Text('Belum ada makanan.'))),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildCardVertical(foodData: foodController.foodList[index]),
          childCount: foodController.foodList.length,
        ),
      );
    });
  }
}

// --- WIDGET CARD DAN BOTTOM SHEET HELPER ---

Widget _buildCardVertical({required Food foodData}) {
  final FoodController foodController = Get.find<FoodController>();
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.grey.shade100,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showFoodDetailSheet(foodData, foodController),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: Image.network(
                    foodData.imageUrl ?? 'https://i.imgur.com/ew28hXp.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, p) => p == null ? child : const SizedBox(height: 150, child: Center(child: CircularProgressIndicator())),
                    errorBuilder: (context, e, s) => Image.asset('assets/images/food_loading_image.png', height: 150, width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                  ),
                  child: Text('Sisa ${foodData.quantity}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodData.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: getAddressFromCoordinates(foodData.location.latitude, foodData.location.longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) return const Text("Memuat alamat...", style: TextStyle(fontSize: 12, color: Colors.grey));
                      return Text(snapshot.data ?? "Alamat tidak tersedia", style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [ const Icon(Icons.star, size: 14, color: Colors.white), const SizedBox(width: 4), const Text('4.9', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))]),
                      ),
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
      width: 200,
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.grey.shade100,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showFoodDetailSheet(foodData, Get.find<FoodController>()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Image.network(
                  foodData.imageUrl ?? 'https://i.imgur.com/ew28hXp.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, p) => p == null ? child : const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                  errorBuilder: (context, e, s) => Image.asset('assets/images/food_loading_image.png', height: 120, width: double.infinity, fit: BoxFit.cover),
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

void _showFoodDetailSheet(Food foodData, FoodController foodController) {
  Get.bottomSheet(
    DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          foodData.imageUrl ?? 'https://i.imgur.com/ew28hXp.png',
                          height: 200, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Image.asset('assets/images/food_loading_image.png', height: 200, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(foodData.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      FutureBuilder<User?>(
                        future: foodController.getVendorForFood(foodData),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Row(children: [CircleAvatar(radius: 15, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 12), Text("Memuat info penjual...")]);
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            final User vendor = snapshot.data!;
                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(vendor.profilePictURL),
                                  onBackgroundImageError: (e, s) => const Icon(Icons.person),
                                ),
                                const SizedBox(width: 12),
                                Text(vendor.username, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            );
                          }
                          return const Row(children: [CircleAvatar(radius: 15, child: Icon(Icons.error)), SizedBox(width: 12), Text("Penjual tidak ditemukan")]);
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(foodData.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 16),
                      const Text('Waktu Pengambilan', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatPickupTime(foodData.pickupStart, foodData.pickupEnd)),
                      const SizedBox(height: 120), // Spacer untuk tombol di bawah
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 5)],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF53B675), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: Text('Tambahkan ke Keranjang - Rp${foodData.priceInRupiah}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

