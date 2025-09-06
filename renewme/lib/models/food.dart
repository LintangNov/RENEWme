import 'package:cloud_firestore/cloud_firestore.dart';

class Food {

  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime expiryDate;

  Food({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl='',
    required this.expiryDate,
  });

  factory Food.fromFirestore(DocumentSnapshot doc){   //ambil data dari firestore
    final data = doc.data() as Map<String, dynamic>;
    return Food(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore(){   //simpan data ke firestore
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'imageUrl' : imageUrl,
      'expiryDate' : expiryDate,
    };
  }
}