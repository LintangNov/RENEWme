import 'package:get/get.dart';
import 'package:renewme/models/cart_item.dart';
import 'package:renewme/models/food.dart';

class CartController extends GetxController{

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.food.priceInRupiah * item.quantity));
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addItem(Food food) {
    // Cek apakah item sudah ada
    final index = cartItems.indexWhere((item) => item.food.id == food.id);

    if (index != -1) {
      // jika ada +quantity
      cartItems[index].quantity++;
    } else {

      cartItems.add(CartItem(food: food, quantity: 1));
    }

    cartItems.refresh();
    Get.snackbar('Berhasil', '${food.name} ditambahkan ke keranjang.');
  }

  void removeItem(Food food) {
    final index = cartItems.indexWhere((item) => item.food.id == food.id);

    if (index != -1) {
      if (cartItems[index].quantity > 1) {
      
        cartItems[index].quantity--;
      } else {

        cartItems.removeAt(index);
      }
      cartItems.refresh();
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}