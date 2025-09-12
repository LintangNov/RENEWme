import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:get/get.dart';

import 'package:renewme/view/dashboard_page.dart';
import 'package:renewme/view/add_item_page/add_food_form.dart';
import 'package:renewme/view/history_page/history_page.dart';
import 'package:renewme/view/personal_page/personal_page.dart';
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
    final List<Widget> pages = [
      const HomePage(),
      const SearchPage(),
      const AddFoodPage(),
      const HistoryPage(),
      const PersonalPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SafeArea(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            //Greeting Text
                            const Text(
                              'Hello',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: verticalPadding * 0.1),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding * 0.4,
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
                }, childCount: 2),
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
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: navController.tabIndex.value,
          onTap: navController.changeTabIndex,
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
              icon: Icon(Icons.search), 
              label: 'Cari'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Tambah'),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_document),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

Widget _buildCardVertical({required Food foodData}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    height: 280,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    foodData.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  Row(
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          // if (foodData.originalPrice > foodData.priceInRupiah)
                          Text(
                            'Rp${foodData.priceInRupiah + 10000}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
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
  return Container(
    height: 100,
    margin: EdgeInsets.all(16),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              width: 80,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'hai',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),

    // InkWell(
    //   borderRadius: BorderRadius.circular(15),
    //   onTap: () {
    //   },
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [

    //       Stack(
    //         children: [
    //           ClipRRect(
    //             borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(15),
    //               topRight: Radius.circular(15),
    //             ),
    //             child: Image.network(

    //               foodData.imageUrl ??
    //                   'https://i.imgur.com/ew28hXp.png',
    //               height: 150,
    //               width: double.infinity,
    //               fit: BoxFit.cover,
    //               // Tampilkan loading indicator saat gambar dimuat
    //               loadingBuilder: (context, child, loadingProgress) {
    //                 if (loadingProgress == null) return child;
    //                 return const SizedBox(
    //                   height: 150,
    //                   child: Center(child: CircularProgressIndicator()),
    //                 );
    //               },

    //               errorBuilder: (context, error, stackTrace) {
    //                 return const SizedBox(
    //                   height: 150,
    //                   child: Icon(
    //                     Icons.broken_image,
    //                     color: Colors.grey,
    //                     size: 48,
    //                   ),
    //                 );
    //               },
    //             ),
    //           ),
    //           Positioned(
    //             top: 12,
    //             child: Container(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 10,
    //                 vertical: 5,
    //               ),
    //               decoration: const BoxDecoration(
    //                 color: Colors.orange,
    //                 borderRadius: BorderRadius.only(
    //                   topRight: Radius.circular(15),
    //                   bottomRight: Radius.circular(15),
    //                 ),
    //               ),
    //               child: Text(
    //                 // Gunakan data kuantitas dari data
    //                 'Sisa ${foodData.quantity}',
    //                 style: const TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 12,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),

    //       Padding(
    //         padding: const EdgeInsets.all(12.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               foodData.name,
    //               style: const TextStyle(
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //               maxLines: 1,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             const SizedBox(height: 4),
    //             Text(
    //               foodData.description,
    //               style: TextStyle(
    //                 fontSize: 12,
    //                 color: Colors.grey.shade600,
    //               ),
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             const SizedBox(height: 12),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Icon(
    //                       Icons.star,
    //                       size: 20,
    //                       color: Colors.orange.shade400,
    //                     ),
    //                     const SizedBox(width: 4),
    //                     const Text(
    //                       '4.9',
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   crossAxisAlignment: CrossAxisAlignment.baseline,
    //                   textBaseline: TextBaseline.alphabetic,
    //                   children: [
    //                     // if (foodData.originalPrice > foodData.priceInRupiah)
    //                     Text(
    //                       'Rp${foodData.priceInRupiah + 10000}',
    //                       style: TextStyle(
    //                         fontSize: 12,
    //                         color: Colors.grey.shade500,
    //                         decoration: TextDecoration.lineThrough,
    //                       ),
    //                     ),
    //                     const SizedBox(width: 8),
    //                     Text(
    //                       'Rp${foodData.priceInRupiah}',
    //                       style: TextStyle(
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.w900,
    //                         color: Colors.green,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
  );
}
