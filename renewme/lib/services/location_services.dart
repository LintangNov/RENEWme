import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationService {
  /// Mendapatkan lokasi pengguna saat ini 
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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
      return Future.error('Layanan lokasi tidak aktif.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Izin Ditolak',
          'Aplikasi tidak dapat berjalan tanpa izin lokasi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        await Future.delayed(const Duration(seconds: 3));
        SystemNavigator.pop(); // Keluar dari aplikasi.
        return Future.error('Izin lokasi ditolak oleh pengguna.');
      }
    }

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

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<List<LatLng>?> getRoute(LatLng start, LatLng end) async {
    // URL OSRM public API
    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson');
    
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
      
        var routeCoordinates = data['routes'][0]['geometry']['coordinates'];
        
        List<LatLng> routePoints = [];
        for (var coordinate in routeCoordinates) {
          routePoints.add(LatLng(coordinate[1], coordinate[0]));
        }
        return routePoints;
      }
    } catch (e) {
      print("Error getting route: $e");
    }
    return null;
  }
}