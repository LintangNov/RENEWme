import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/view/search_page/search_page.dart';

// --- MERGE: Struktur StatefulWidget milikmu tetap dipertahankan ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variabel dan controller tetap sama seperti milikmu
  final FoodController foodController = Get.find<FoodController>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    // Definisi ukuran layar agar mudah diakses
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding =
        screenWidth * 0.05; // Sedikit disesuaikan agar lebih pas

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        // --- MERGE: Fitur 1 -> Menambahkan RefreshIndicator dari AI ---
        // Membungkus CustomScrollView agar bisa ditarik untuk refresh
        child: RefreshIndicator(
          onRefresh: () async {
            // Logika refresh diambil dari AI: memuat ulang lokasi dan data makanan
            await userController.updateUserLocationAndAddress();
            await foodController.fetchAllFoods();
          },
          child: CustomScrollView(
            slivers: [
              // --- MERGE: Fitur 2 & 3 -> AppBar dengan Nama & Lokasi Dinamis ---
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                expandedHeight: screenHeight * 0.25,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      SvgPicture.asset(
                        'assets/images/background.svg',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Padding(
                          // Memberi ruang untuk search bar di bawah
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Teks sambutan dengan nama pengguna dari UserController
                              Obx(
                                () => Text(
                                  'Welcome, ${userController.currentUser.value?.username ?? 'Tamu'}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Lokasi Anda saat ini:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Tampilan lokasi dengan status loading
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Obx(() {
                                      if (userController
                                              .isFetchingLocation
                                              .value ||
                                          userController
                                              .isFetchingAddress
                                              .value) {
                                        return const Text(
                                          'Mencari lokasi anda...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        );
                                      }
                                      return Text(
                                        userController.userAddress.value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
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
                // --- MERGE: Fitur 4 -> Search bar yang lebih rapi ---
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(25),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      readOnly: true,
                      onTap:
                          () => Get.to(
                            () => const SearchPage(),
                          ), // Navigasi pakai GetX
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Cari makanan...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),

              // --- MERGE: Judul seksi "Promo" langsung di sini ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🔥 Promo Hari Ini',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- MERGE: Daftar makanan horizontal "Promo" langsung di sini ---
              Obx(() {
                if (foodController.isLoading.value &&
                    foodController.foodList.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
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
                      itemBuilder: (context, index) {
                        return _buildCardHorizontal(
                          foodData: promoItems[index],
                        );
                      },
                    ),
                  ),
                );
              }),

              // --- MERGE: Judul seksi "Rekomendasi" langsung di sini ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rekomendasi Untukmu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Lihat Semua',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- MERGE: Daftar vertikal dengan loading & empty state dari AI ---
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
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final food = foodController.foodList[index];
                    return _buildCardVertical(foodData: food);
                  }, childCount: foodController.foodList.length),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // --- MERGE: Meng-upgrade _buildCardVertical dengan versi AI yang lebih baik ---
  Widget _buildCardVertical({required Food foodData}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.grey.shade100,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.bottomSheet(
              isScrollControlled: true,
              Container(
                height: 300,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: const [
                    Text(
                      'Ini Bottom Sheet!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Kamu bisa taruh apa aja di sini.'),
                  ],
                ),
              ),
              // Opsi tambahan (opsional)
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      // Null-safe check, jika null pakai gambar placeholder
                      foodData.imageUrl.toString(),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (context, child, progress) =>
                              progress == null
                                  ? child
                                  : const SizedBox(
                                    height: 150,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                      errorBuilder:
                          (context, error, stack) => Image.asset(
                            'assets/images/food_loading_image.png',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Sisa ${foodData.quantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodData.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      foodData.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              const Text(
                                '4.9',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Rp${foodData.priceInRupiah}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.green,
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
      ),
    );
  }

  // --- MERGE: Meng-upgrade _buildCardHorizontal dengan versi AI yang lebih baik ---
  Widget _buildCardHorizontal({required Food foodData}) {
    return Container(
      width: 200, // Sedikit diperlebar agar lebih proporsional
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.grey.shade100,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            /* TODO: Navigasi ke detail page */
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      // Null-safe check, jika null pakai gambar placeholder
                      foodData.imageUrl.toString(),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (context, child, progress) =>
                              progress == null
                                  ? child
                                  : const SizedBox(
                                    height: 120,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                      errorBuilder:
                          (context, error, stack) => Image.asset(
                            'assets/images/food_loading_image.png',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Sisa ${foodData.quantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        foodData.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        // food.description,
                        'Ambil hari ini, 09.00 - 10.00',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 50,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.9',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                'Rp${foodData.priceInRupiah}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                ),
                              ),
                            ],
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
  }
}
