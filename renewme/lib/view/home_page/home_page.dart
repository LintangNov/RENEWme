import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:get/get.dart';


import 'package:renewme/view/search_page/search_page.dart';
import 'package:renewme/controllers/navigation_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  final FoodController foodController = Get.find<FoodController>();
  double get horizontalPadding => screenWidth * 0.1;
  double get verticalPadding => screenWidth * 0.1;

  final NavigationController navController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditampilkan sesuai urutan di BottomNavigationBar
    // final List<Widget> pages = [
    //   const HomePage(),
    //   const SearchPage(),
    //   const AddFoodPage(),
    //   const HistoryPage(),
    //   const PersonalPage(),
    // ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        child: CustomScrollView(
          slivers: [
            // Ganti semua header-mu sebelumnya dengan SATU SliverAppBar ini
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shadowColor: Colors.black38,
              expandedHeight: screenHeight * 0.25,

              // AppBar on Top
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    SizedBox.expand(
                      child: SvgPicture.asset(
                        'assets/images/background.svg',
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          //Greeting Text
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          //Location Title
                          const Text(
                            'Pesan sekarang,',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          // Geo Map Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Jl. Kebon Jeruk No.27, Jakarta',
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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

              // App Bar on Scroll
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(35),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchPage()),
                      );
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mau makan apa..',
                      prefixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Section Title 0
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding * 0.4,
                  right: horizontalPadding * 0.4,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🔥Promo Hari Ini',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildCardHorizontal(
                  foodData: Food(
                    id: 'food_$index',
                    name: 'Mie Ayam Spesial $index',
                    description: 'Mie ayam',
                    imageUrl:
                        'https://www.jagel.id/api/listimage/v/Siomay-Bandung-0-16461987aca51125.jpg',
                    expiryDate: DateTime.now().add(Duration(days: 5 + index)),
                    quantity: 5 - index,
                    priceInRupiah: 15000 + (index * 5000),
                  ),
                );
              }, childCount: 1),
            ),

            // Section Title 0
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terdekat dari kamu',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildCardHorizontal(
                  foodData: Food(
                    id: 'food_$index',
                    name: 'Mie Ayam Spesial $index',
                    description: 'Mie ayam',
                    imageUrl:
                        'https://www.jagel.id/api/listimage/v/Siomay-Bandung-0-16461987aca51125.jpg',
                    expiryDate: DateTime.now().add(Duration(days: 5 + index)),
                    quantity: 5 - index,
                    priceInRupiah: 15000 + (index * 5000),
                  ),
                );
              }, childCount: 1),
            ),

            // Section Title 1
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.5,
                  vertical: verticalPadding * 0.1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rekomendasi untukmu',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Item List 1
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildCardVertical(
                  foodData: Food(
                    id: 'food_$index',
                    name: 'Mie Ayam Spesial $index',
                    description: 'Mie ayam',
                    imageUrl:
                        'https://www.jagel.id/api/listimage/v/Siomay-Bandung-0-16461987aca51125.jpg',
                    expiryDate: DateTime.now().add(Duration(days: 5 + index)),
                    quantity: 5 - index,
                    priceInRupiah: 15000 + (index * 5000),
                  ),
                );
              }, childCount: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardVertical({required Food foodData}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 250,
      width: 400,
      // Material & InkWell untuk efek ripple yang benar
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        elevation: 2,
        shadowColor: Colors.grey.shade100,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      foodData.imageUrl ?? 'https://i.imgur.com/ew28hXp.png',
                      height: 150,
                      width: 388,
                      fit: BoxFit.cover,
                      // Tampilkan loading indicator saat gambar dimuat
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 150,
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Text(
                        // Gunakan data kuantitas dari data
                        'Sisa ${foodData.quantity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '4.9',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 100,
                              child: Text(
                                'Ambil hari ini, 19.00 - 10.00',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                softWrap: true,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            // if (foodData.originalPrice > foodData.priceInRupiah)
                            // Text(
                            //   'Rp${foodData.priceInRupiah + 10000}',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: Colors.grey.shade500,
                            //     decoration: TextDecoration.lineThrough,
                            //   ),
                            // ),
                            const SizedBox(width: 8),
                            Text(
                              'Rp${foodData.priceInRupiah}',
                              style: TextStyle(
                                fontSize: 20,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHorizontal({required Food foodData}) {
    return SizedBox(
      height: 260, // WAJIB kasih height!
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // itemCount: foodController.foodList.length,
        itemCount: 4,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          // Food food = foodController.foodList[index]; // Ambil data per index
          // Food food = 3; // Ambil data per index

          return Container(
            width: 180, // Lebar card
            margin: EdgeInsets.only(right: 16, top: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                // print('Tapped: ${food.name}');
                print('Tapped: bro');
                // Tambahkan navigasi atau action lain di sini
              },
              borderRadius: BorderRadius.circular(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bagian gambar
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.network(
                          // food.imageUrl ??
                          'https://picsum.photos/200/150?random=$index',
                          width: 250,
                          height: 125,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.food_bank,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                        ),
                      ),
                      // Badge sisa
                      Positioned(
                        top: 8,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            // 'Sisa ${food.quantity}',
                            'Sisa 4',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Bagian text
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            // food.name,
                            'Mie Ayam Spesial',
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
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.orange.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '4.9',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
    );
  }
}
