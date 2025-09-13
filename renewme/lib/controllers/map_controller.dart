import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';

class MapController extends GetxController{

  final FoodController foodController = Get.find<FoodController>();
  final UserController userController = Get.find<UserController>();

  final RxList<Marker> markers = <Marker>[].obs;
  final Rx<LatLng> initialCenter = const LatLng(-6.2088, 106.8456).obs; // Default: Jakarta
  final RxBool isLoading = true.obs;

   @override
  void onInit() {
    super.onInit();
    // Panggil method untuk menyiapkan semua data peta
    _prepareMapData();
  }

  /// Method utama untuk menyiapkan semua data yang dibutuhkan oleh peta.
  Future<void> _prepareMapData() async {
    try {
      isLoading.value = true;
      
      // 3. Tentukan posisi awal peta
      // Jika lokasi user ada, gunakan itu. Jika tidak, tetap gunakan default.
      if (userController.userPosition.value != null) {
        final userPos = userController.userPosition.value!;
        initialCenter.value = LatLng(userPos.latitude, userPos.longitude);
      }
      
      // 4. Konversi daftar makanan menjadi daftar marker
      final foodMarkers = foodController.foodList.map((food) {
        return Marker(
          point: LatLng(food.location.latitude, food.location.longitude),
          width: 80,
          height: 80,
          child: IconButton(
            icon: const Icon(Icons.fastfood, color: Colors.orange, size: 35),
            onPressed: () {
              onMarkerTapped(food.name, food.priceInRupiah);
            },
          ),
        );
      }).toList();

      // 5. Update state markers
      markers.assignAll(foodMarkers);

    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data peta: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Aksi yang terjadi saat marker di-tap.
  void onMarkerTapped(String foodName, int price) {
    Get.snackbar(
      foodName,
      "Harga: Rp$price",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
    );
  }
}