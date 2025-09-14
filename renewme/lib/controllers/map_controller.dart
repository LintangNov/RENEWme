import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart'; // Diperlukan untuk memformat waktu
import 'package:latlong2/latlong.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/food.dart';

class MapController extends GetxController {
  // Mengambil dependency dari controller lain yang sudah ada.
  final FoodController _foodController = Get.find<FoodController>();
  final UserController _userController = Get.find<UserController>();

  // Variabel reaktif untuk state peta.
  final RxList<Marker> markers = <Marker>[].obs;
  final Rx<LatLng> initialCenter = const LatLng(-6.2088, 106.8456).obs; // Default: Jakarta
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Menyiapkan data awal saat controller pertama kali dimuat.
    _prepareMapData();

    // Menggunakan `ever` untuk mendengarkan perubahan pada foodList.
    // Ini akan membuat peta selalu update secara real-time.
    ever(_foodController.foodList, (_) => _rebuildMarkers());
  }

  /// Menyiapkan data awal peta, terutama posisi tengah kamera.
  void _prepareMapData() {
    isLoading.value = true;
    // Jika lokasi user ada, gunakan itu sebagai titik tengah.
    if (_userController.userPosition.value != null) {
      final userPos = _userController.userPosition.value!;
      initialCenter.value = LatLng(userPos.latitude, userPos.longitude);
    }
    _rebuildMarkers(); // Membangun daftar marker untuk pertama kali.
    isLoading.value = false;
  }

  /// Membangun ulang daftar marker dari foodList terbaru.
  void _rebuildMarkers() {
    // 1. Konversi daftar makanan menjadi daftar marker.
    final foodMarkers = _foodController.foodList.map((food) {
      return Marker(
        point: LatLng(food.location.latitude, food.location.longitude),
        width: 80,
        height: 80,
        child: IconButton(
          icon: const Icon(Icons.fastfood, color: Colors.orange, size: 35),
          onPressed: () => onMarkerTapped(food),
        ),
      );
    }).toList();

    // 2. (Bonus) Tambahkan marker untuk lokasi pengguna.
    if (_userController.userPosition.value != null) {
      final userPos = _userController.userPosition.value!;
      foodMarkers.add(
        Marker(
          point: LatLng(userPos.latitude, userPos.longitude),
          child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
        ),
      );
    }

    // 3. Update state markers agar UI ikut berubah.
    markers.assignAll(foodMarkers);
  }

  /// Aksi yang terjadi saat marker makanan di-tap.
  void onMarkerTapped(Food food) {
    // Format waktu mulai dan selesai menjadi string "HH:mm"
    final startTime = DateFormat('HH:mm').format(food.pickupStart);
    final endTime = DateFormat('HH:mm').format(food.pickupEnd);
    final pickupTime = 'Ambil: $startTime - $endTime';

    Get.snackbar(
      food.name,
      "Harga: Rp${food.priceInRupiah}\n$pickupTime", // Tampilkan info waktu pengambilan
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.7),
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }
}

