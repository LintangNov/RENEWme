import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/models/food.dart';

class RestoPage extends StatefulWidget {
  const RestoPage({super.key});

  @override
  State<RestoPage> createState() => _RestoPageState();
}

class _RestoPageState extends State<RestoPage> {
  late final ScrollController _scrollController;
  bool _isAppBarSolid = false;
  final FoodController foodController = Get.find<FoodController>();
  final Map<String, int> _itemCounters = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_appBarListener);
  }

  void _appBarListener() {
    if (_scrollController.offset > 200 && !_isAppBarSolid) {
      setState(() {
        _isAppBarSolid = true;
      });
    } else if (_scrollController.offset <= 200 && _isAppBarSolid) {
      setState(() {
        _isAppBarSolid = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_appBarListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Method untuk menghitung total item yang dipilih
  int get totalItems {
    return _itemCounters.values.fold(0, (sum, count) => sum + count);
  }

  // Method untuk menghitung total harga
  double get totalPrice {
    double total = 0;
    _itemCounters.forEach((foodId, count) {
      if (count > 0) {
        final food = foodController.foodList.firstWhere((f) => f.id == foodId);
        total += food.priceInRupiah * count;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(),
                _buildRestoInfoCard(),
                _buildMenuListTitle(),
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
                      return _buildMenuList(foodData: food);
                    }, childCount: foodController.foodList.length),
                  );
                }),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            // Checkout button yang muncul ketika ada item yang dipilih
            if (totalItems > 0) _buildFloatingCheckoutButton(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      backgroundColor: _isAppBarSolid ? Colors.white : Colors.transparent,
      elevation: _isAppBarSolid ? 2.0 : 0.0,
      leading: IconButton(
        onPressed: () {
          Get.back(); // Karena Anda pakai GetX
          // atau Navigator.pop(context); jika tidak pakai GetX
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: _isAppBarSolid ? Colors.black87 : Colors.white,
        ),
      ),
      iconTheme: IconThemeData(
        color: _isAppBarSolid ? Colors.black87 : Colors.white,
      ),

      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_border,
            color: _isAppBarSolid ? Colors.black87 : Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.share,
            color: _isAppBarSolid ? Colors.black87 : Colors.white,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
          fit: BoxFit.cover,
          color: Colors.black.withOpacity(0.3),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRestoInfoCard() {
    return SliverToBoxAdapter(
      child: Container(
        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salad',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Diskon 20%',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Nikmati aneka salad dengan bahan-bahan segar langsung dari petani lokal. Pilihan sempurna untuk makan siang sehatmu!',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 4),
                Text(
                  '(200+ ulasan)',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(width: 12),
                Icon(Icons.location_on, color: Colors.grey, size: 20),
                SizedBox(width: 4),
                Text(
                  '2.1 km',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMenuListTitle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: const Text(
          'Menu Kami',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildMenuList({required Food foodData}) {
    var counter = _itemCounters[foodData.id] ?? 0;
    return SizedBox(
      height: 150,
      child: Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    foodData.imageUrl.toString(),
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, progress) =>
                            progress == null
                                ? child
                                : const SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                    errorBuilder:
                        (context, error, stack) => Image.asset(
                          'assets/images/food_loading_image.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            foodData.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            foodData.description,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sisa ${foodData.quantity}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${foodData.priceInRupiah}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (counter > 0) ...[
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_itemCounters[foodData.id]! > 1) {
                                        _itemCounters[foodData.id] =
                                            counter - 1;
                                      } else {
                                        _itemCounters.remove(foodData.id);
                                      }
                                    });
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '$counter',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: () {
                                  if (counter < foodData.quantity) {
                                    setState(() {
                                      _itemCounters[foodData.id] = counter + 1;
                                    });
                                  } else {
                                    // Tampilkan pesan jika stok habis
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Stok makanan tidak mencukupi!',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCheckoutButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '$totalItems item${totalItems > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text('Rp ${totalPrice.toInt()}'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Handle checkout action
                print('Checkout with total: Rp ${totalPrice.toInt()}');
                print('Total items: $totalItems');
                // - Rp ${totalPrice.toInt()}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF53B675),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Pesan Sekarang',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
