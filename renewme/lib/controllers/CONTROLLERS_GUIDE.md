# USER CONTROLLER GUIDE

### 1. instalasi
    a. tambahkan paket get & user_cotroller:
        import 'package:get/get.dart';
        import 'package:renewme/controllers/user_controller.dart';
    b. hubungkan firebase, inisiasi service & repo, inisiasi controller
        copy-paste ke main.dart diatas runApp():
        // Hubungkan Firebase [1]
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp();

        // Inisialisasi service dan repository sebagai dependensi [2]
        Get.put(AuthService());
        Get.put(FirestoreService());
        Get.put(UserRepository(Get.find(), Get.find()));

        // Inisialisasi UserController agar dapat diakses oleh semua View
        Get.put(UserController());

### 2. variabel observable (jika berubah, tampilan juga berubah)
    - Rx<User?> currentUser; // data user yang sedang login, kalau tidak login nilainya null
    - RxBool isLoading; // bernilai true saat loading berlangsung
    - RxString errorMessage; // pesan kesalahan kalau ada kegagalan. berisi string kosong kalau tidak ada kesalahan ('')
    - `Rx<Position?> userPosition`; // Menyimpan data lokasi GPS pengguna (latitude & longitude). Bernilai `null` jika lokasi belum didapatkan.
    *note: Rx = reactive (merubah tampilan kalau nilainya berubah)

### 3. daftar method siap pakai
    a. authentication
        # registerUser({required String email,required String password, required String username, required GeoPoint location, required String phoneNumber})
        - method pendaftaran akun baru
        - cara pakai: panggil di bagian onPressed dari button "register/daftar"
        - jangan lupa kasih snackbar kalau error & keterangan loading
        # signIn({required String email, required String password})
        - login akun yg sudah ada
        - panggil di onPressed button "masuk"
        # signOut()
        - sign out akun
        - cara pakai: panggil di onPressed button "logout"
        # deleteUserAccount()
        - hapus akun dari auth & firestore
        - pakai ini setelah minimal 1 kali konfirmasi dari user
    b. pengelolaan akun
        # fetchCurrentUser()
        - load data user yang login
        - dipanggil otomatis saat controller onInit (diinisiasi)
        - panggil lagi setelah profil diubah (untuk refresh)
        # updateUserProfile({required String username, String? profilePhotoUrl, GeoPoint? location})
        - panggil di bagian edit profil
        # updateUserLocation()
        - Meminta izin & mengambil lokasi GPS pengguna saat ini, lalu menyimpannya ke variabel userPosition. Dipanggil saat fitur berbasis lokasi dibutuhkan.
### 4. contoh di view (source: Gemini)


    // lib/views/login_page.dart
    import 'package:flutter/material.dart';
    import 'package:get/get.dart';
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:flutter_app_mvc/controllers/user_controller.dart';
    import 'package:flutter_app_mvc/views/home_page.dart';

    class LoginPage extends StatelessWidget {
    // Temukan instance UserController yang sudah diinisialisasi [3]
    final UserController userController = Get.find<UserController>();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        // Gunakan Obx untuk mengawasi status [4]
        return Obx(() {
        return Scaffold(
            appBar: AppBar(title: Text('Login')),
            body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: userController.isLoading.value // Tampilkan indikator loading jika isLoading true [4]
                ? CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            await userController.signIn(
                                email: emailController.text,
                                password: passwordController.text,
                            );
                            // Navigasi jika berhasil
                            if (userController.isLoggedIn()) {
                                Get.offAll(() => HomePage());
                            }
                            },
                            child: Text('Masuk'),
                        ),
                        SizedBox(height: 10),
                        if (userController.errorMessage.isNotEmpty)
                            Text(
                            userController.errorMessage.value,
                            style: TextStyle(color: Colors.red),
                            ),
                        ],
                    ),
            ),
            ),
        );
        });
    }
    }


# FOOD CONTROLLER GUIDE


### 1. Instalasi
   a. Hubungkan controller di dalam View:
      `final FoodController foodController = Get.find<FoodController>();`

### 2. Variabel Observable
   - `RxList<Food> foodList`: Daftar semua produk makanan.
   - `RxBool isLoading`: Status loading khusus untuk operasi makanan.
   - `RxString errorMessage`: Pesan kesalahan khusus untuk operasi makanan.

### 3. Daftar Method Siap Pakai
   a. Manajemen Data (CRUD)
      - `fetchAllFoods()`: Memuat semua data makanan dari Firestore.
      - `addFood(Food food)`: Menambahkan dokumen makanan baru.
      - `updateFood(Food food)`: Memperbarui dokumen makanan yang sudah ada.
      - `deleteFood(String foodId)`: Menghapus dokumen makanan.
   
   b. Sorting & Filtering
      - `sortFoodsByPrice({bool ascending = true})`: Mengurutkan `foodList` berdasarkan harga (termurah/termahal).
      - `sortFoodsByDistance()`: Mengurutkan `foodList` berdasarkan jarak terdekat dari pengguna. Method ini akan otomatis meminta lokasi jika belum ada.