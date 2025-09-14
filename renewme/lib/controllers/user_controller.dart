// lib/controllers/user_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renewme/models/user.dart';
import 'package:renewme/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renewme/view/dashboard_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:renewme/services/location_services.dart';
import 'package:renewme/utils/location_helper.dart';

class UserController extends GetxController {
  // Deklarasi Repository sebagai dependensi.
  final UserRepository _userRepository = Get.find<UserRepository>();
  final LocationService _locationService = Get.find<LocationService>();

  // '.obs' (observable) membuat variabel ini reaktif,
  // sehingga setiap perubahan akan memicu refresh di UI.
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Position?> userPosition = Rx<Position?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isUpdatingProfile = false.obs; 
  final RxBool isFetchingLocation = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString userAddress = "".obs; 
  final RxBool isFetchingAddress = false.obs;

  final isHidePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Memuat data pengguna saat controller pertama kali diinisialisasi.
    fetchCurrentUser();
  }

  void changePasswordVisibility() {
    isHidePassword.value = !isHidePassword.value;
  }

  // mengambil data pengguna yang sedang login.
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

  // --- Method Autentikasi ---

  // Mendaftarkan pengguna baru dengan memanggil repository.
  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
    GeoPoint? location = const GeoPoint(0, 0),
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
      if (newUser != null) {
        currentUser.value = newUser;
        // ke halaman utama
        Get.offAll(() => DashboardPage());
        await updateUserLocation();
      }
    } catch (e) {
      errorMessage.value = 'Gagal mendaftar. Silakan coba lagi.';
      print('Error registration: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in
  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final user = await _userRepository.signIn(email, password);
      if (user != null) {
        currentUser.value = user;
        // ke halaman utama
        Get.offAll(() => DashboardPage());
        await updateUserLocation();
      }
    } catch (e) {
      errorMessage.value = 'Login gagal. Cek email dan kata sandi Anda.';
      print('Error signing in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout akun.
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

  // Update profil pengguna.
  Future<void> updateUserProfile({
    required String username,
    String? profilePhotoUrl,
    GeoPoint? location,
  }) async {
    isUpdatingProfile.value = true;
    errorMessage.value = '';
    try {
      if (currentUser.value != null) {
        final updatedUser = User(
          id: currentUser.value!.id,
          username: username,
          email: currentUser.value!.email,
          location: location ?? currentUser.value!.location,
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
      isUpdatingProfile.value = false;
    }
  }

  // Hapus akun pengguna.
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

  Future<void> updateUserLocation() async {
    isFetchingLocation.value = true; // Gunakan state loading terpisah
    errorMessage.value = '';
    try {
      final position = await _locationService.getCurrentLocation();
      userPosition.value = position;

      
      if (currentUser.value != null) {
        final newLocation = GeoPoint(position.latitude, position.longitude);
        
        await updateUserProfile(
          username: currentUser.value!.username,
          location: newLocation,
        );
        Get.snackbar(
          'Lokasi Diperbarui',
          'Lokasi Anda berhasil didapatkan dan disimpan.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar('Lokasi Didapatkan', 'Lokasi Anda berhasil didapatkan.');
      }
      
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Gagal Mendapatkan Lokasi',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isFetchingLocation.value = false; 
    }
  }

  Future<void> fetchUserAddress() async {
    if (userPosition.value == null) {
      await updateUserLocation(); 
      if (userPosition.value == null) {
        Get.snackbar('Error', 'Lokasi pengguna tidak ditemukan.');
        return;
      }
    }
    
    try {
      isFetchingAddress.value = true;
      final position = userPosition.value!;
      
      // Panggil fungsi helper dari file terpisah
      final String address = await getAddressFromCoordinates(
        position.latitude,
        position.longitude
      );
      
      userAddress.value = address;

    } catch (e) {
      userAddress.value = 'Gagal mengambil alamat.';
    } finally {
      isFetchingAddress.value = false;
    }
  }
  // Cek apakah pengguna sedang login.
  bool isLoggedIn() {
    return currentUser.value != null;
  }
}
