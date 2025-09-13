// lib/utils/location_helper.dart
import 'package:geocoding/geocoding.dart';

/// Mengubah koordinat Latitude dan Longitude menjadi alamat yang bisa dibaca.
/// Mengembalikan sebuah String alamat, atau pesan error jika gagal.
Future<String> getAddressFromCoordinates(double lat, double lon) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      // Format alamat menjadi lebih ringkas dan rapi
      return "${place.street}, ${place.subLocality}, ${place.locality}";
    }
    return "Alamat tidak ditemukan.";
  } catch (e) {
    print("Error getting address: $e");
    return "Gagal mendapatkan alamat";
  }
}