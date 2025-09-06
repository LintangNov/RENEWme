// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renewme/models/user.dart';


class firestoreService {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  /// Menyimpan / update data pengguna di Firestore
  Future<void> saveUser(user user) async {
    final userRef = _usersCollection.doc(user.id);
    await userRef.set(user.toFirestore());
  }

  /// Mengambil data pengguna dari Firestore berdasarkan UID
  Future<user?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return user.fromFirestore(doc);
    }
    return null;
  }
  
  /// Menghapus data pengguna dari Firestore
  Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }
}