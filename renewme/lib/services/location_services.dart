import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';


class LocationService {
  /// Mendapatkan lokasi pengguna saat ini dengan alur baru.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan lokasi (GPS) di perangkat aktif.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // JIKA GPS TIDAK AKTIF: Tampilkan dialog untuk meminta pengguna mengaktifkannya.
      await Get.defaultDialog(
        title: "GPS Tidak Aktif",
        middleText: "Aplikasi ini membutuhkan GPS untuk menemukan lokasi. Mohon aktifkan GPS.",
        textConfirm: "Buka Pengaturan",
        textCancel: "Batal",
        onConfirm: () async {
          // Arahkan pengguna ke pengaturan lokasi perangkat.
          await Geolocator.openLocationSettings();
          Get.back(); // Tutup dialog
        },
      );
      // Kembalikan error karena proses tidak bisa dilanjutkan saat ini.
      return Future.error('Layanan lokasi tidak aktif.');
    }

    // 2. Cek status izin yang sudah diberikan.
    permission = await Geolocator.checkPermission();

    // 3. Jika izin ditolak (denied), minta izin secara eksplisit.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      
      // JIKA IZIN DITOLAK LAGI: Tampilkan snackbar lalu keluar dari aplikasi.
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Izin Ditolak',
          'Aplikasi tidak dapat berjalan tanpa izin lokasi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Tunggu 3 detik agar snackbar terlihat, lalu tutup aplikasi.
        await Future.delayed(const Duration(seconds: 3));
        SystemNavigator.pop(); // Keluar dari aplikasi.
        return Future.error('Izin lokasi ditolak oleh pengguna.');
      }
    }

    // 4. Jika izin ditolak permanen, beri tahu pengguna dan keluar.
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Izin Ditolak Permanen',
        'Anda harus mengaktifkan izin lokasi manual di pengaturan aplikasi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      await Future.delayed(const Duration(seconds: 4));
      SystemNavigator.pop(); // Keluar dari aplikasi.
      return Future.error('Izin lokasi ditolak permanen.');
    }

    // 5. Jika semua izin beres, dapatkan posisi pengguna.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}