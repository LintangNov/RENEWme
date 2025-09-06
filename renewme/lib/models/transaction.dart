import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String userId;
  final String foodId;
  final DateTime transactionDate;
  final String status;
  final String? notes;

  Transaction({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.transactionDate,
    required this.status,
    this.notes,
  });

  factory Transaction.fromFirestore(DocumentSnapshot doc) {   //ambil data dari firestore
    final data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: doc.id,
      userId: data['userId'] ?? '',
      foodId: data['foodId'] ?? '',
      transactionDate: (data['transactionDate'] as Timestamp).toDate(),
      status: data['status'] ?? '',
      notes: data['notes'],
    );
  }

  factory Transaction.toFirestore(Map<String, dynamic> map) {       //simpan data ke firestore
    return Transaction(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      foodId: map['foodId'] ?? '',
      transactionDate: (map['transactionDate'] as Timestamp).toDate(),
      status: map['status'] ?? '',
      notes: map['notes'],
    );
  }
}