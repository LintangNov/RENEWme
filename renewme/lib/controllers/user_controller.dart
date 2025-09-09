// lib/controllers/user_controller.dart
import 'package:get/get.dart';
import 'package:renewme/models/user.dart';
import 'package:renewme/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// UserController mengelola semua logika dan state yang berkaitan dengan pengguna.
// Dengan GetX, controller ini bisa diakses dan diperbarui dari mana saja.
class UserController extends GetxController {
  // Deklarasi Repository sebagai dependensi.
  // GetX akan secara otomatis menemukan instance UserRepository yang telah terdaftar.
  final UserRepository _userRepository = Get.find<UserRepository>();

  // Variabel reaktif untuk menyimpan state aplikasi.
  // '.obs' (observable) membuat variabel ini reaktif,
  // sehingga setiap perubahan akan memicu rebuild di UI.
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Memuat data pengguna saat controller pertama kali diinisialisasi.
    // Ini penting untuk menjaga sesi login.
    fetchCurrentUser();
  }

  // Metode ini mengambil data pengguna yang sedang login.
  Future<void> fetchCurrentUser() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _userRepository.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = 'Gagal memuat data pengguna.';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // --- Metode untuk Autentikasi ---

  /// Mendaftarkan pengguna baru dengan memanggil repository.
  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
    required GeoPoint location,
    required String phoneNumber,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final newUser = await _userRepository.registerUser(
        email,
        password,
        username,
        location,
        phoneNumber,

      );
      if (newUser!= null) {
        currentUser.value = newUser;
        // Opsional: Navigasi ke halaman utama
        // Get.offAll(() => HomePage());
      }
    } catch (e) {
      errorMessage.value = 'Gagal mendaftar. Silakan coba lagi.';
      print('Error registration: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Masuk dengan akun yang sudah ada.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _userRepository.signIn(email, password);
      if (user!= null) {
        currentUser.value = user;
        // Opsional: Navigasi ke halaman utama
        // Get.offAll(() => HomePage());
      }
    } catch (e) {
      errorMessage.value = 'Login gagal. Cek email dan kata sandi Anda.';
      print('Error signing in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Keluar dari akun.
  Future<void> signOut() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _userRepository.signOut();
      currentUser.value = null;
      // Opsional: Navigasi kembali ke halaman login.
      // Get.offAll(() => LoginPage());
    } catch (e) {
      errorMessage.value = 'Gagal keluar. Silakan coba lagi.';
      print('Error signing out: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- Metode untuk Pengelolaan Profil ---

  /// Memperbarui data profil pengguna.
  Future<void> updateUserProfile({
    required String username,
    String? profilePhotoUrl,
    GeoPoint? location,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      if (currentUser.value!= null) {
        final updatedUser = User(
          id: currentUser.value!.id,
          username: username,
          email: currentUser.value!.email,
          location: location?? currentUser.value!.location,
          profilePictURL: currentUser.value!.profilePictURL,
          phoneNumber: currentUser.value!.phoneNumber,
        );
        await _userRepository.updateUser(updatedUser);
        currentUser.value = updatedUser;
        // Tampilkan pesan sukses
        Get.snackbar('Sukses', 'Profil berhasil diperbarui.');
      }
    } catch (e) {
      errorMessage.value = 'Gagal memperbarui profil. Silakan coba lagi.';
      print('Error updating user: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Menghapus akun pengguna.
  Future<void> deleteUserAccount() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _userRepository.deleteUserAccount();
      currentUser.value = null;
      // Opsional: Navigasi kembali ke halaman login.
      // Get.offAll(() => LoginPage());
      Get.snackbar('Sukses', 'Akun berhasil dihapus.');
    } catch (e) {
      errorMessage.value = 'Gagal menghapus akun. Silakan coba lagi.';
      print('Error deleting user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengecek apakah pengguna sedang login.
  bool isLoggedIn() {
    return currentUser.value!= null;
  }
}