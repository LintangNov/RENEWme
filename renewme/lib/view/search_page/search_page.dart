import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/controllers/food_controller.dart';
// 1. Pastikan Anda mengimpor file controller yang benar
import 'package:renewme/controllers/search_page_controller.dart'; 
import 'package:renewme/models/food.dart';


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Inisialisasi SearchPageController Anda dengan benar
    final SearchPageController searchController = Get.put(SearchPageController());
    final FoodController foodController = Get.find<FoodController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian'),
      ),
      body: Column(
        children: [
          // 3. Kirim controller yang benar ke helper method
          _buildSearchBar(searchController),

          _buildFilterButtons(foodController),

          const Divider(height: 1),

          Expanded(
            child: Obx(() {
              // 4. Gunakan variabel controller yang benar di semua logika
              if (searchController.textController.text.isEmpty) {
                return _buildSearchHistory(searchController);
              }
              
              if (foodController.isLoading.value || (searchController.isSearching.value && searchController.searchResultList.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (searchController.searchResultList.isEmpty) {
                return const Center(child: Text('Makanan tidak ditemukan.'));
              }

              return _buildSearchResults(searchController);
            }),
          ),
        ],
      ),
    );
  }

  // 5. Perbaiki tipe parameter di semua helper method
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

  Widget _buildSearchHistory(SearchPageController controller) {
    if (controller.searchHistory.isEmpty) {
      return const Center(child: Text('Ketik untuk mulai mencari makanan.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Riwayat Pencarian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: controller.clearHistory,
                child: const Text('Hapus'),
              ),
            ],
          ),
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
  
  Widget _buildSearchResults(SearchPageController controller) {
    return ListView.builder(
      itemCount: controller.searchResultList.length,
      itemBuilder: (context, index) {
        final Food food = controller.searchResultList[index];
        return _buildFoodListItem(food);
      },
    );
  }
  
  Widget _buildFoodListItem(Food food) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
