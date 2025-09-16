import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/repositories/food_repository.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/user.dart';
import 'package:renewme/repositories/user_repository.dart';
import 'package:renewme/utils/location_helper.dart';


class FoodWithDistance {
  final Food food;
  final double distanceInMeters;

  FoodWithDistance({required this.food, required this.distanceInMeters});
}

class FoodController extends GetxController {
  final FoodRepository _foodRepository = Get.find<FoodRepository>();

  final UserController _userController = Get.find<UserController>();

  final UserRepository _userRepository = Get.find<UserRepository>();


  final Map<String, String> _addressCache = {};
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

  String getFoodDistanceString(Food food) {
    
    if (_userController.userPosition.value != null) {
      final userPos = _userController.userPosition.value!;
      
      final double distanceInMeters = Geolocator.distanceBetween(
        userPos.latitude,
        userPos.longitude,
        food.location.latitude,
        food.location.longitude,
      );

      // Konversi ke kilometer dan format menjadi string.
      final double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km'; 
    }
    return '-- km';
  }

  Future<User?> getVendorForFood(Food food) async {
    try {
      // Memanggil repository pengguna untuk mendapatkan data berdasarkan vendorId
      final vendor = await _userRepository.getUserById(food.vendorId);
      return vendor;
    } catch (e) {
      print("Error fetching vendor for food ${food.id}: $e");
      Get.snackbar('Error', 'Gagal mendapatkan data penjual.');
      return null;
    }
  }

  Future<String> getVendorAddress(Food food) async {
    final String cacheKey = food.id;

    
    if (_addressCache.containsKey(cacheKey)) {
      return _addressCache[cacheKey]!;
    }

    final String address = await getAddressFromCoordinates(
      food.location.latitude,
      food.location.longitude,
    );
    _addressCache[cacheKey] = address;
    return address;
  }
}