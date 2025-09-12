// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renewme/models/food.dart';
import 'package:renewme/models/user.dart';
import 'package:renewme/models/transaction.dart';


class FirestoreService {
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _foodsCollection = FirebaseFirestore.instance.collection('foods');

//// USERS
  /// Menyimpan / update data pengguna di Firestore
  Future<void> saveUser(User user) async {
    final userRef = _usersCollection.doc(user.id);
    await userRef.set(user.toFirestore());
  }

  /// Mengambil data pengguna dari Firestore berdasarkan UID
  Future<User?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return User.fromFirestore(doc);
    }
    return null;
  }
  
  /// Menghapus data pengguna dari Firestore
  Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }

  //// FOODS
  
  Future<List<Food>> getFoods() async {
    final snapshot = await _foodsCollection.get();
    return snapshot.docs.map((doc) => Food.fromFirestore(doc)).toList();
  }

  /// Menambahkan makanan baru.
  /// Firestore akan otomatis membuat ID unik.
  Future<void> addFood(Food food) async {
    await _foodsCollection.add(food.toFirestore());
  }

  Future<void> updateFood(Food food) async {
    await _foodsCollection.doc(food.id).update(food.toFirestore());
  }

  Future<void> deleteFood(String foodId) async {
    await _foodsCollection.doc(foodId).delete();
  }
}