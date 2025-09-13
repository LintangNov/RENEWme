import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/repositories/food_repository.dart';
import 'package:renewme/controllers/user_controller.dart';


class FoodWithDistance {
  final Food food;
  final double distanceInMeters;

  FoodWithDistance({required this.food, required this.distanceInMeters});
}

class FoodController extends GetxController {
  final FoodRepository _foodRepository = Get.find<FoodRepository>();

  final UserController _userController = Get.find<UserController>();

  // variabel reaktif
  final RxList<Food> foodList = <Food>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit(){
    super.onInit();
    fetchAllFoods();
  }

  // load makanan
  Future<void> fetchAllFoods() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final foods = await _foodRepository.getAllFoods();
      foodList.assignAll(foods);

    } catch (e) {
      errorMessage.value = 'Gagal memuat data makanan.';
      print('Error fetching foods: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // tambah makanan
  Future<void> addFood(Food food) async {
    try {
      isLoading.value = true;
      await _foodRepository.addFood(food);
      fetchAllFoods(); // Muat ulang data setelah menambahkan
      Get.snackbar('Sukses', 'Makanan berhasil ditambahkan.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan makanan.');
      print('Error adding food: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // update makanan
  Future<void> updateFood(Food food) async {
  try {
    isLoading.value = true;
    await _foodRepository.updateFood(food);
    

    int index = foodList.indexWhere((item) => item.id == food.id);
    if (index != -1) {

      foodList[index] = food;
    }

    Get.snackbar("Sukses", "Makanan berhasil diperbarui.");
  } catch (e) {
    // ...
  } finally {
    isLoading.value = false;
  }
}

  // hapus makanan

  Future<void> deleteFood(String foodId) async {
  try {
    isLoading.value = true;
    await _foodRepository.deleteFood(foodId);
    
    // --- OPTIMASI ---
    // Hapus item dari list berdasarkan ID-nya.
    foodList.removeWhere((item) => item.id == foodId);
    // -----------------
    
    Get.snackbar('Sukses', 'Makanan berhasil dihapus.');
  } catch (e) {
    // ...
  } finally {
    isLoading.value = false;
  }
}

  void sortFoodsByPrice({bool ascending = true}) {
    foodList.sort((a, b) {
      if (ascending) {
        return a.priceInRupiah.compareTo(b.priceInRupiah); // Termurah ke termahal
      } else {
        return b.priceInRupiah.compareTo(a.priceInRupiah); // Termahal ke termurah
      }
    });
  }

  Future<void> sortFoodsByDistance() async {
    // 1. Cek apakah lokasi pengguna sudah ada.
    if (_userController.userPosition.value == null) {
      // 2. Jika tidak ada, panggil method di UserController untuk mendapatkannya.
      await _userController.updateUserLocation();
      
      // 3. Cek sekali lagi. Jika masih null (misalnya, pengguna menolak izin), hentikan proses.
      if (_userController.userPosition.value == null) {
        Get.snackbar('Lokasi Dibutuhkan', 'Izin lokasi diperlukan untuk fitur ini.');
        return;
      }
    }

    try {
      isLoading.value = true;

      // 4. Langsung gunakan lokasi dari UserController
      final Position userPosition = _userController.userPosition.value!;

      // Proses sorting tetap sama, tapi tidak perlu lagi memanggil service lokasi
      final List<FoodWithDistance> foodsWithDistances = foodList.map((food) {
        final double distance = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          food.location.latitude,
          food.location.longitude,
        );
        return FoodWithDistance(food: food, distanceInMeters: distance);
      }).toList();

      foodsWithDistances.sort((a, b) {
        final distanceComparison =
            a.distanceInMeters.compareTo(b.distanceInMeters);
        if (distanceComparison != 0) {
          return distanceComparison;
        } else {
          return a.food.priceInRupiah.compareTo(b.food.priceInRupiah);
        }
      });

      final List<Food> sortedFoods =
          foodsWithDistances.map((item) => item.food).toList();
      foodList.assignAll(sortedFoods);

    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat mengurutkan data.';
      Get.snackbar('Error', errorMessage.value);
      print('Error sorting by distance: $e');
    } finally {
      isLoading.value = false;
    }
  }
}