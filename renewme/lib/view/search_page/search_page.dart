import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/search_page_controller.dart';
import 'package:renewme/models/food.dart';


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.put() agar SearchController dibuat khusus untuk halaman ini
    final SearchPageController searchPageController = Get.put(SearchPageController());
    // Gunakan Get.find() untuk FoodController yang sudah ada
    final FoodController foodController = Get.find<FoodController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian'),
        // Tombol kembali secara otomatis ditambahkan oleh GetX saat navigasi
      ),
      body: Column(
        children: [
          // 1. Bagian Search Bar
          _buildSearchBar(searchPageController),

          // 2. Bagian Tombol Filter/Sorting
          _buildFilterButtons(foodController),

          const Divider(height: 1),

          // 3. Bagian Konten Dinamis (Riwayat atau Hasil Pencarian)
          Expanded(
            child: Obx(() {
              // Jika query di TextField kosong, tampilkan riwayat
              if (searchPageController.textController.text.isEmpty) {
                return _buildSearchHistory(searchPageController);
              }
              
              // Jika sedang loading/debounce, tampilkan spinner
              if (foodController.isLoading.value || (searchPageController.isSearching.value && searchPageController.searchResultList.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Jika tidak ada hasil, tampilkan pesan
              if (searchPageController.searchResultList.isEmpty) {
                return const Center(child: Text('Makanan tidak ditemukan.'));
              }

              // Jika ada hasil, tampilkan daftar hasil pencarian
              return _buildSearchResults(searchPageController);
            }),
          ),
        ],
      ),
    );
  }

  // Widget untuk Search Bar
  Widget _buildSearchBar(SearchPageController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller.textController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Cari nama makanan...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onChanged: controller.searchFoods,
        onSubmitted: controller.addToHistory,
      ),
    );
  }
  
  // Widget untuk tombol-tombol filter
  Widget _buildFilterButtons(FoodController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FilterChip(
            label: const Text('Terdekat'),
            onSelected: (selected) {
              if (selected) controller.sortFoodsByDistance();
            },
          ),
          FilterChip(
            label: const Text('Termurah'),
            onSelected: (selected) {
              if (selected) controller.sortFoodsByPrice(ascending: true);
            },
          ),
          FilterChip(
            label: const Text('Termahal'),
            onSelected: (selected) {
              if (selected) controller.sortFoodsByPrice(ascending: false);
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan Riwayat Pencarian
  Widget _buildSearchHistory(SearchPageController controller) {
    if (controller.searchHistory.isEmpty) {
      return const Center(child: Text('Ketik untuk mulai mencari makanan.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Riwayat Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, index) {
              final query = controller.searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                onTap: () {
                  controller.textController.text = query;
                  controller.textController.selection = TextSelection.fromPosition(TextPosition(offset: query.length));
                  controller.searchFoods(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Widget untuk menampilkan Hasil Pencarian
  Widget _buildSearchResults(SearchPageController controller) {
    return ListView.builder(
      itemCount: controller.searchResultList.length,
      itemBuilder: (context, index) {
        final Food food = controller.searchResultList[index];
        // Ini adalah layout list item seperti di gambar Anda
        return _buildFoodListItem(food);
      },
    );
  }
  
  // Widget untuk satu item makanan dalam daftar hasil
  Widget _buildFoodListItem(Food food) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Makanan (Placeholder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              image: food.imageUrl != null && food.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(food.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (food.imageUrl == null || food.imageUrl!.isEmpty)
                ? const Icon(Icons.image, color: Colors.white, size: 40)
                : null,
          ),
          const SizedBox(width: 16),
          // Kolom untuk Teks (Nama, Deskripsi, Harga)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  food.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  food.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                 const SizedBox(height: 8),
                Text(
                  'Rp${food.priceInRupiah}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}