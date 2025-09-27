import 'package:renewme/models/food.dart';

class CartItem {
  final Food food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });
}