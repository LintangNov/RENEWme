import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/models/food.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchController extends GetxController {

  final FoodController _foodController = Get.find<FoodController>();
  
  // Controller untuk text field di UI agar bisa dikontrol dari sini.
  late TextEditingController textController;

  // Variabel reaktif 
  final RxList<Food> searchResultList = <Food>[].obs;
  final RxList<String> searchHistory = <String>[].obs;
  final RxBool isSearching = false.obs;
  
  // Kunci unik untuk menyimpan data riwayat di SharedPreferences.
  static const _historyKey = 'search_history';

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    // Memuat riwayat pencarian dari memori saat controller dibuat.
    _loadSearchHistory(); 
  }

  /// Melakukan pencarian berdasarkan query dengan debounce.
  void searchFoods(String query) {
    // Jika query kosong, bersihkan hasil pencarian dan tampilkan riwayat.
    if (query.isEmpty) {
      searchResultList.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    // Debounce: Tunda eksekusi pencarian selama 500ms setelah pengguna berhenti mengetik.
    debounce(
      isSearching,
      (_) {
        // Ambil daftar makanan utama dari FoodController.
        final masterList = _foodController.foodList;
        // Lakukan filter berdasarkan nama makanan.
        final results = masterList.where((food) {
          final foodName = food.name.toLowerCase();
          final input = query.toLowerCase();
          return foodName.contains(input);
        }).toList();
        // Update daftar hasil pencarian.
        searchResultList.assignAll(results);
      },
      time: const Duration(milliseconds: 500),
    );
  }
  
  /// Menambahkan query ke riwayat pencarian dan menyimpannya.
  void addToHistory(String query) {
    if (query.isEmpty || searchHistory.contains(query)) {
      return;
    }
    searchHistory.insert(0, query); // Tambahkan ke paling atas.
    // Batasi riwayat hanya 10 item terakhir.
    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }
    // Simpan riwayat yang sudah diperbarui.
    _saveSearchHistory();
  }

  /// Membersihkan riwayat pencarian.
  void clearHistory() {
    searchHistory.clear();
    // Hapus juga dari memori.
    _clearSavedHistory();
  }

  // --- Method Internal untuk SharedPreferences ---

  /// Menyimpan daftar `searchHistory` ke memori perangkat.
  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, searchHistory);
  }

  /// Memuat daftar `searchHistory` dari memori perangkat.
  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getStringList(_historyKey);
    if (savedHistory != null) {
      searchHistory.assignAll(savedHistory);
    }
  }
  
  /// Menghapus data riwayat dari memori perangkat.
  Future<void> _clearSavedHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Membersihkan resource saat controller dihapus dari memori.
  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}