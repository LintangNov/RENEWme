import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final GeoPoint? location;
  final String phoneNumber;
  final String profilePictURL;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.location,
    required this.phoneNumber,
    this.profilePictURL = '',
  });

  factory User.fromFirestore(DocumentSnapshot doc) {      //ambil data dari firestore

    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username']?? '',
      email: data['email']?? '',
      location: data['location'],
      profilePictURL: data['profile_pict_url'],
      phoneNumber: data['phone_number']?? '',
    );
  }

  Map<String, dynamic> toFirestore() {        //simpan data ke firestore
    return {
      'username': username,
      'email': email,
      'location': location,
      'profile_pict_url': profilePictURL,
      'phone_number': phoneNumber,
    };
  }
}