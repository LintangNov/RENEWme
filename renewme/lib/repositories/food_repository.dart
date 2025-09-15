import 'package:renewme/models/food.dart';
import 'package:renewme/services/firestore_services.dart';
import 'package:renewme/models/user.dart';


class FoodRepository {

  final  FirestoreService _firestoreService;

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

  // Di dalam class UserRepository di file lib/repositories/user_repository.dart

  /// Mengambil data pengguna spesifik berdasarkan UID.
  Future<User?> getUserById(String uid) {
    // Meneruskan permintaan ke FirestoreService.
    return _firestoreService.getUser(uid);
  }
 }