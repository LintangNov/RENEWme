import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:renewme/controllers/food_controller.dart';
import 'package:renewme/controllers/user_controller.dart';
import 'package:renewme/models/food.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FoodController foodController = Get.find<FoodController>();
  final UserController userController = Get.find<UserController>();

  // Controller untuk setiap input field di form.
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  // --- PERUBAHAN: Variabel state untuk rentang waktu pengambilan ---
  DateTime? _selectedPickupStart;
  DateTime? _selectedPickupEnd;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Makanan Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Makanan', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
                validator: (value) => (value == null || value.isEmpty) ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga (Rupiah)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Kuantitas / Sisa', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => (value == null || value.isEmpty) ? 'Kuantitas tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              // --- PERUBAHAN: Dua tombol untuk memilih rentang waktu ---
              const Text("Waktu Mulai Pengambilan", style: TextStyle(fontWeight: FontWeight.bold)),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedPickupStart == null ? 'Pilih Tanggal & Waktu' : DateFormat('dd MMM yyyy, HH:mm').format(_selectedPickupStart!)),
                onPressed: _pickPickupStart,
              ),
              const SizedBox(height: 16),
              const Text("Waktu Selesai Pengambilan", style: TextStyle(fontWeight: FontWeight.bold)),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedPickupEnd == null ? 'Pilih Tanggal & Waktu' : DateFormat('dd MMM yyyy, HH:mm').format(_selectedPickupEnd!)),
                onPressed: _pickPickupEnd,
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _saveFood,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text("Simpan Makanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Memilih waktu mulai pengambilan.
  Future<void> _pickPickupStart() async {
    final selectedDateTime = await _selectDateTime(context, initialDate: DateTime.now(), firstDate: DateTime.now());
    if (selectedDateTime != null) {
      setState(() {
        _selectedPickupStart = selectedDateTime;
        // Jika waktu selesai lebih awal dari waktu mulai yang baru, reset waktu selesai.
        if (_selectedPickupEnd != null && _selectedPickupEnd!.isBefore(_selectedPickupStart!)) {
          _selectedPickupEnd = null;
        }
      });
    }
  }

  /// Memilih waktu selesai pengambilan.
  Future<void> _pickPickupEnd() async {
    if (_selectedPickupStart == null) {
      Get.snackbar('Perhatian', 'Silakan pilih waktu mulai terlebih dahulu.');
      return;
    }
    final selectedDateTime = await _selectDateTime(context, initialDate: _selectedPickupStart!, firstDate: _selectedPickupStart!);
    if (selectedDateTime != null) {
      setState(() {
        _selectedPickupEnd = selectedDateTime;
      });
    }
  }

  /// Fungsi yang dipanggil saat tombol "Simpan Makanan" ditekan.
  void _saveFood() {
    // 1. Validasi semua input form.
    if (!_formKey.currentState!.validate() || _selectedPickupStart == null || _selectedPickupEnd == null) {
      Get.snackbar(
        "Input Tidak Lengkap",
        "Semua field, termasuk waktu mulai dan selesai, wajib diisi.",
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
      imageUrl: '', 
      vendorId: userController.currentUser.value!.id,
      location: userController.currentUser.value!.location!,
      // --- PERUBAHAN: Gunakan pickupStart dan pickupEnd ---
      pickupStart: _selectedPickupStart!,
      pickupEnd: _selectedPickupEnd!,
    );

    // 3. Panggil method addFood dari controller untuk menyimpan data.
    foodController.addFood(newFood);
  }
}

/// Helper method untuk menampilkan dialog tanggal dan waktu.
Future<DateTime?> _selectDateTime(BuildContext context, {required DateTime initialDate, required DateTime firstDate}) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: DateTime(2101),
  );

  if (pickedDate == null) return null;

  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );

  if (pickedTime == null) return null;

  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
