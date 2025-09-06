
import 'package:renewme/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renewme/services/auth_services.dart';
import 'package:renewme/services/firestore_services.dart';

/// userRepository mengelola logika bisnis terkait pengguna,
/// menyambung antara authService dan firestoreService
class userRepository {
  final authService _authService;
  final firestoreService _firestoreService;

  userRepository(this._authService, this. _firestoreService);

  // --- Operasi Autentikasi dan Profil ---

  /// Mendaftarkan pengguna baru dan menyimpan data profilnya.
  Future<User?> registeruser(String email, String password, String username, GeoPoint location, String phoneNumber) async {
    try {
      // Langkah 1: Buat akun di Firebase Auth.
      final userCredential = await _authService.registerEmailPassword(email, password);
      
      if (userCredential?.user!= null) {
        final uid = userCredential!.user!.uid;
        
        // Langkah 2: Buat objek user dan simpan profilnya di Firestore.
        final newuser = User(
          id: uid,
          username: username,
          email: email,
          location: location,
          phoneNumber: phoneNumber,
        );
        await _firestoreService.saveUser(newuser);
        
        return newuser;
      }
    } on FirebaseException {
      rethrow;
    }
    return null;
  }

  /// Masuk dengan akun yang sudah ada.
  Future<User?> signIn(String email, String password) async {
    try {
      // Langkah 1: Masuk ke Firebase Auth.
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      
      if (userCredential?.user!= null) {
        // Langkah 2: Ambil data profil dari Firestore menggunakan UID.
        final uid = userCredential!.user!.uid;
        return await _firestoreService.getUser(uid);
      }
    } on FirebaseException {
      rethrow;
    }
    return null;
  }
  
  /// Keluar dari akun.
  Future<void> signOut() async {
    await _authService.signOut();
  }
  
  /// Mengambil data pengguna yang sedang login.
  Future<User?> getCurrentUser() async {
    final uid = _authService.getCurrentUserId();
    if (uid!= null) {
      return await _firestoreService.getUser(uid);
    }
    return null;
  }
  
  // --- Operasi CRUD Data Profil Pengguna ---

  /// Memperbarui data profil pengguna.
  /// Ini adalah operasi 'Update'.
  Future<void> updateuser(User user) async {
    await _firestoreService.saveUser(user);
  }

  /// Menghapus akun pengguna dan data profilnya.
  /// Ini adalah operasi 'Delete' yang menggabungkan dua layanan.
  Future<void> deleteUserAccount() async {
    final uid = _authService.getCurrentUserId();
    if (uid!= null) {
      // Hapus data profil dari Firestore terlebih dahulu.
      await _firestoreService.deleteUser(uid);
      // Kemudian, hapus akun pengguna dari Firebase Auth.
      await _authService.deleteAuthUser();
    }
  }
}