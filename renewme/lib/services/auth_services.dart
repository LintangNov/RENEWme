import 'package:firebase_auth/firebase_auth.dart';

class authService{
  final FirebaseAuth _auth = FirebaseAuth.instance;


   //Register ke auth
  Future<UserCredential?> registerEmailPassword(String email, String password) async {   
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow; 
    }
  }

   //login ke akun
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {  
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException {
      rethrow; // Melemparkan kembali exception.
    }
  }

  //logout dari akun
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Dapatkan id user yang login
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // hapus akun user dari auth    
  Future<void> deleteAuthUser() async {
    await _auth.currentUser?.delete();
  }
}