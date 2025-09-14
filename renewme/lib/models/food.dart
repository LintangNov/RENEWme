import 'package:cloud_firestore/cloud_firestore.dart';

class Food {

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int quantity;
  final int priceInRupiah;
  final String vendorId;
  final GeoPoint location;
final DateTime pickupStart;
  final DateTime pickupEnd;

  Food({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl = '',
    this.quantity = 1,
    this.priceInRupiah = 0,
    required this.vendorId,
    required this.location,
    // --- PARAMETER BARU ---
    required this.pickupStart,
    required this.pickupEnd,
  });

  factory Food.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Default ke waktu saat ini jika data tidak ada di Firestore
    final now = Timestamp.now();
    return Food(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      quantity: data['quantity'] ?? 1,
      priceInRupiah: data['priceInRupiah'] ?? 0,
      vendorId: data['vendorId'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      // --- ASSIGNMENT BARU ---
      // Firestore menyimpan DateTime sebagai Timestamp, jadi kita perlu konversi.
      pickupStart: (data['pickupStart'] as Timestamp? ?? now).toDate(),
      pickupEnd: (data['pickupEnd'] as Timestamp? ?? now).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'priceInRupiah': priceInRupiah,
      'vendorId': vendorId,
      'location': location,
      // --- MAP BARU ---
      // Objek DateTime dari Dart akan otomatis diubah menjadi Timestamp oleh Firestore.
      'pickupStart': pickupStart,
      'pickupEnd': pickupEnd,
    };
  }
}

