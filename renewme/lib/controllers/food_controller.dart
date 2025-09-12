import 'package:get/get.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/repositories/food_repository.dart';

class FoodController extends GetxController {
  final FoodRepository _foodRepository = Get.find<FoodRepository>();

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
      fetchAllFoods();
      Get.snackbar("Sukses", "Makanan berhasil diperbarui.");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui makanan.");
      print('Error updating food: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // hapus makanan

  Future<void> deleteFood(String foodId) async {
    try {
      isLoading.value = true;
      await _foodRepository.deleteFood(foodId);
      fetchAllFoods();
      Get.snackbar('Sukses', 'Makanan berhasil dihapus.');
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus makanan.");
      print('Error deleting food: $e');
    } finally {
      isLoading.value = false;
    }
  }
}