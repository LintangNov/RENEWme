import 'package:cloud_firestore/cloud_firestore.dart';

class user {
  final String id;
  final String username;
  final String email;
  final GeoPoint? location;
  final String phoneNumber;
  final String profilePictURL;

  user({
    required this.id,
    required this.username,
    required this.email,
    this.location,
    required this.phoneNumber,
    this.profilePictURL = '',
  });

  factory user.fromFirestore(DocumentSnapshot doc) {

    final data = doc.data() as Map<String, dynamic>;
    return user(
      id: doc.id,
      username: data['username']?? '',
      email: data['email']?? '',
      location: data['location'],
      profilePictURL: data['profile_pict_url'],
      phoneNumber: data['phone_number']?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'location': location,
      'profile_pict_url': profilePictURL,
      'phone_number': phoneNumber,
    };
  }
}