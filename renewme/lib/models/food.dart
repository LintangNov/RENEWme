import 'package:cloud_firestore/cloud_firestore.dart';

class Food {

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime expiryDate;
  final int quantity;
  final int priceInRupiah;
  final String vendorId;
  final GeoPoint location;

  Food({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl='',
    required this.expiryDate,
    this.quantity=1,
    this.priceInRupiah=0,
    required this.vendorId,
    required this.location,
  });

  factory Food.fromFirestore(DocumentSnapshot doc){   //ambil data dari firestore
    final data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? 'assets/images/food_loading.png',
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      quantity: data['quantity'] ?? 1,
      priceInRupiah: data['priceInRupiah'] ?? 0,
      vendorId: data['vendorId'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toFirestore(){   //simpan data ke firestore
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'imageUrl' : imageUrl,
      'expiryDate' : expiryDate,
      'quantity' : quantity,
      'priceInRupiah' : priceInRupiah,
      'vendorId' : vendorId,
      'location' : location,
    };
  }
}