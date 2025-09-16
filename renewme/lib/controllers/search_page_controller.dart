import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class SearchPageController extends GetxController {

  final FoodController _foodController = Get.find<FoodController>();
    final UserController _userController = Get.find<UserController>();

  
  late TextEditingController textController;

  final RxList<Food> searchResultList = <Food>[].obs;
  final RxList<String> searchHistory = <String>[].obs;
  final RxBool isSearching = false.obs;
  
  static const _historyKey = 'search_history';

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    _loadSearchHistory(); 
  }

  void searchFoods(String query) {
    if (query.isEmpty) {
      searchResultList.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    debounce(
      isSearching,
      (_) {
        final masterList = _foodController.foodList;
        final results = masterList.where((food) {
          final foodName = food.name.toLowerCase();
          final input = query.toLowerCase();
          return foodName.contains(input);
        }).toList();
        searchResultList.assignAll(results);
        isSearching.value=false;
      },
      time: const Duration(milliseconds: 500),
    );
  }
  
  void addToHistory(String query) {
    if (query.isEmpty || searchHistory.contains(query)) {
      return;
    }
    searchHistory.insert(0, query);
    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }
    _saveSearchHistory();
  }

  void clearHistory() {
    searchHistory.clear();
    _clearSavedHistory();
  }

  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, searchHistory);
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getStringList(_historyKey);
    if (savedHistory != null) {
      searchHistory.assignAll(savedHistory);
    }
  }
  
  Future<void> _clearSavedHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void sortResultsByPrice({bool ascending = true}) {
    
    final listToSort = searchResultList.isNotEmpty ? List<Food>.from(searchResultList) : List<Food>.from(_foodController.foodList);

    listToSort.sort((a, b) {
      if (ascending) {
        return a.priceInRupiah.compareTo(b.priceInRupiah);
      } else {
        return b.priceInRupiah.compareTo(a.priceInRupiah);
      }
    });
    
    // Tampilkan hasilnya di searchResultList
    searchResultList.assignAll(listToSort);
  }

  /// Mengurutkan hasil pencarian berdasarkan jarak.
  Future<void> sortResultsByDistance() async {
    isSearching.value = true; // Gunakan state loading yang sama
    try {
      if (_userController.userPosition.value == null) {
        await _userController.updateUserLocation();
        if (_userController.userPosition.value == null) {
          Get.snackbar('Lokasi Dibutuhkan', 'Izin lokasi diperlukan untuk fitur ini.');
          return;
        }
      }

      final Position userPosition = _userController.userPosition.value!;
      // Tentukan daftar mana yang akan diurutkan
      final listToSort = searchResultList.isNotEmpty ? List<Food>.from(searchResultList) : List<Food>.from(_foodController.foodList);

      final List<FoodWithDistance> foodsWithDistances = listToSort.map((food) {
        final double distance = Geolocator.distanceBetween(
          userPosition.latitude, userPosition.longitude,
          food.location.latitude, food.location.longitude,
        );
        return FoodWithDistance(food: food, distanceInMeters: distance);
      }).toList();

      foodsWithDistances.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

      final sortedFoods = foodsWithDistances.map((item) => item.food).toList();
      searchResultList.assignAll(sortedFoods);

    } catch (e) {
      Get.snackbar('Error', 'Gagal mengurutkan berdasarkan jarak.');
    } finally {
      isSearching.value = false;
    }
  }
}

