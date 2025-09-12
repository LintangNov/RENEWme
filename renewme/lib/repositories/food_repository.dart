import 'package:renewme/models/food.dart';
import 'package:renewme/services/firestore_services.dart';


class FoodRepository {

   FirestoreService _firestoreService = FirestoreService();

  FoodRepository(this._firestoreService);

  Future<List<Food>> getAllFoods() async {
    return await _firestoreService.getFoods();
  }

  Future<void> addFood(Food food) async {
    return await _firestoreService.addFood(food);
  }

  Future<void> updateFood(Food food) async {
    await _firestoreService.updateFood(food);
  }

  Future<void> deleteFood(String foodId) async {
    await _firestoreService.deleteFood(foodId);
  }
 }