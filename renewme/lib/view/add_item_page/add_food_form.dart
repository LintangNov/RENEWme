import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/models/food.dart';

/// Halaman Form untuk Menambah Data Makanan Baru.
class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  // Controller untuk setiap input field di form.
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  // Variabel state untuk menyimpan tanggal kedaluwarsa yang dipilih.
  DateTime? _selectedExpiryDate;

  // Mengambil instance FoodController yang dikelola oleh GetX.
  final FoodController foodController = Get.find<FoodController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Makanan Baru"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input field untuk nama makanan.
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
              ),
              const SizedBox(height: 16),

              // Input field untuk deskripsi.
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),

              // Input field untuk harga.
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rupiah)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.price_change),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Input field untuk kuantitas/stok.
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Kuantitas / Sisa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Baris untuk menampilkan dan memilih tanggal kedaluwarsa.
              const Text(
                'Tanggal Kedaluwarsa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedExpiryDate == null
                      ? 'Pilih Tanggal & Waktu'
                      // Format tanggal agar mudah dibaca oleh pengguna.
                      : DateFormat('dd MMMM yyyy, HH:mm').format(_selectedExpiryDate!),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.centerLeft,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _pickExpiryDateTime,
              ),
              const SizedBox(height: 32),

              // Tombol untuk menyimpan data ke Firestore.
              ElevatedButton(
                onPressed: _saveFood,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text("Simpan Makanan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fungsi untuk memicu dialog pemilihan tanggal dan waktu.
  Future<void> _pickExpiryDateTime() async {
    // Panggil helper method untuk menampilkan dialog.
    final selectedDateTime = await _selectExpiryDateTime(context);

    // Jika pengguna memilih tanggal (tidak membatalkan), update state.
    if (selectedDateTime != null) {
      setState(() {
        _selectedExpiryDate = selectedDateTime;
      });
    }
  }

  /// Fungsi yang dipanggil saat tombol "Simpan Makanan" ditekan.
  void _saveFood() {
    // 1. Validasi input: pastikan field yang wajib diisi tidak kosong.
    if (_nameController.text.isEmpty || _selectedExpiryDate == null) {
      Get.snackbar(
        "Input Tidak Lengkap",
        "Nama dan tanggal kedaluwarsa wajib diisi.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Buat objek Food baru dari data yang diinput pengguna.
    final newFood = Food(
      id: '', // ID dikosongkan karena akan dibuat otomatis oleh Firestore.
      name: _nameController.text,
      description: _descriptionController.text,
      priceInRupiah: int.tryParse(_priceController.text) ?? 0,
      quantity: int.tryParse(_quantityController.text) ?? 1,
      expiryDate: _selectedExpiryDate!,
      imageUrl: '', // Anda bisa menambahkan input untuk URL gambar nanti.
    );

    // 3. Panggil method addFood dari controller untuk menyimpan data.
    foodController.addFood(newFood);

    // 4. Kembali ke halaman sebelumnya setelah data berhasil disimpan.
    Get.back();
  }
}

/// Helper method di luar class State untuk menampilkan dialog tanggal dan waktu.
Future<DateTime?> _selectExpiryDateTime(BuildContext context) async {
  // Tampilkan dialog untuk memilih tanggal.
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(), // Tanggal paling awal adalah hari ini.
    lastDate: DateTime(2101),
  );

  if (pickedDate == null) return null; // Pengguna membatalkan.

  // Tampilkan dialog untuk memilih waktu.
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(DateTime.now()),
  );

  if (pickedTime == null) return null; // Pengguna membatalkan.

  // Gabungkan hasil tanggal dan waktu menjadi satu objek DateTime.
  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}