File ini mencakup panduan penggunaan dari:
- UserController
- FoodController
- SearchController
- MapController
- CartController

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
   c. Helper & Data Tambahan
      - `getDistanceStringForFood(Food food)`: Mengambil satu objek Food, menghitung jaraknya dari lokasi pengguna, dan mengembalikan String yang sudah diformat (contoh: "1.2 km"). Berguna untuk ditampilkan di kartu makanan.

      - `getVendorForFood(Food food)`: Mengambil satu objek Food, mencari data penjualnya (vendorId) di database, dan mengembalikan Future<User?>. Berguna untuk menampilkan detail penjual.

# SEARCH CONTROLLER GUIDE

Controller ini dirancang khusus untuk mengelola semua logika di halaman pencarian, termasuk input pengguna, hasil filter, dan riwayat pencarian.

### 1. Instalasi
Controller ini bersifat spesifik untuk satu halaman, jadi cara inisialisasinya sedikit berbeda.

   a. **Dependensi**: Pastikan `FoodController` sudah terdaftar di `main.dart`. `SearchController` membutuhkan `FoodController` untuk mendapatkan data master makanan.

   b. **Inisialisasi di View**: Inisialisasi controller ini langsung di dalam `build` method halaman `SearchPage.dart` menggunakan `Get.put()`. GetX akan secara otomatis membuat dan menghapusnya saat halaman dibuka dan ditutup.
   
      ```dart
      // file: lib/view/search_page/search_page.dart
      
      final SearchController controller = Get.put(SearchController());
      ```

### 2. Variabel Penting
Akses variabel ini dari View melalui `controller` yang sudah Anda inisialisasi.

* `TextEditingController textController`: Hubungkan ini ke `TextField` pencarian Anda untuk mengontrol teks input.
* `RxList<Food> searchResultList`: **(Observable)** Daftar makanan hasil filter yang cocok dengan query pencarian.
* `RxList<String> searchHistory`: **(Observable)** Daftar query (teks) yang pernah dicari oleh pengguna. Daftar ini akan otomatis tersimpan di memori perangkat.
* `RxBool isSearching`: **(Observable)** Bernilai `true` saat pengguna sedang mengetik dan proses *debounce* sedang menunggu untuk dijalankan.

### 3. Daftar Method Siap Pakai

* `searchFoods(String query)`
    * Method utama untuk melakukan pencarian secara *real-time*.
    * **Cara Pakai**: Hubungkan ke properti `onChanged` dari `TextField` pencarian.
    * **Catatan**: Method ini sudah dilengkapi *debounce* secara otomatis, sehingga pencarian hanya akan berjalan setelah pengguna berhenti mengetik sejenak.

* `addToHistory(String query)`
    * Menambahkan teks pencarian ke dalam daftar riwayat dan menyimpannya secara permanen.
    * **Cara Pakai**: Hubungkan ke properti `onSubmitted` dari `TextField`, atau panggil saat pengguna memilih salah satu item dari hasil pencarian.

* `clearHistory()`
    * Menghapus semua data riwayat pencarian dari tampilan dan memori perangkat.
    * **Cara Pakai**: Panggil dari `onPressed` sebuah tombol "Hapus Riwayat".

### 4. Konsep Penting: Debouncing
Controller ini menggunakan teknik `debounce` pada method `searchFoods`. Artinya, logika pencarian **tidak dijalankan pada setiap karakter yang diketik**, melainkan akan menunggu jeda singkat (500 milidetik) setelah pengguna berhenti mengetik. Ini membuat aplikasi jauh lebih efisien dan responsif.

# MAP CONTROLLER GUIDE 

Controller ini bertugas sebagai "otak" di belakang layar untuk halaman peta. Ia mengambil data dari `UserController` dan `FoodController`, lalu menyiapkannya agar bisa ditampilkan dengan mudah oleh widget peta.

### 1. Instalasi & Dependensi
Controller ini dirancang untuk digunakan secara spesifik pada halaman peta.

   a. **Dependensi**: Pastikan `UserController` dan `FoodController` sudah terdaftar di `main.dart` karena `MapController` membutuhkan keduanya untuk berfungsi.

   b. **Inisialisasi di View**: Inisialisasi controller ini langsung di dalam `build` method halaman `MapPage.dart` menggunakan `Get.put()`. GetX akan otomatis membuat dan menghapusnya saat halaman dibuka dan ditutup.
   
      ```dart
      // file: lib/view/map_page.dart
      
      final MapController controller = Get.put(MapController());
      ```

### 2. Variabel Observable
Akses variabel ini dari `MapPage` melalui `controller` yang sudah diinisialisasi.

* `RxList<Marker> markers`: Daftar penanda (marker) yang akan ditampilkan di peta. Daftar ini dibuat secara otomatis berdasarkan data di `foodList`.
* `Rx<LatLng> initialCenter`: Titik tengah peta saat pertama kali dimuat. Secara default akan berpusat di Jakarta, tetapi akan otomatis menggunakan lokasi pengguna jika tersedia di `UserController`.
* `RxBool isLoading`: Bernilai `true` saat controller sedang menyiapkan semua data peta. UI bisa menampilkan `CircularProgressIndicator` saat state ini aktif.

### 3. Method Siap Pakai

Sebagian besar logika di controller ini berjalan otomatis saat diinisialisasi (`onInit`). Method publik utamanya adalah untuk interaksi.

* `onMarkerTapped(String foodName, int price)`
    * **Fungsi**: Method yang dipanggil saat sebuah marker di peta ditekan.
    * **Aksi**: Akan menampilkan `Snackbar` di bagian bawah layar yang berisi nama dan harga makanan.
    * **Cara Pakai**: Method ini sudah terhubung secara otomatis ke properti `onPressed` dari setiap `IconButton` di dalam marker yang dibuat oleh controller.

# CART CONTROLLER GUIDE 
Controller ini mengelola semua data dan logika yang berhubungan dengan keranjang belanja pengguna, seperti daftar item, total harga, dan jumlah item.

### 1. Instalasi
Controller ini bersifat global dan harus tersedia di seluruh aplikasi.

a. Dependensi: Pastikan Anda sudah membuat model CartItem di lib/models/cart_item.dart.

b. Inisialisasi di main.dart: CartController harus diinisialisasi sebagai singleton menggunakan Get.put() di dalam fungsi initDependencies() agar datanya tidak hilang saat berpindah halaman. (Lihat bagian "Langkah Awal" di atas).

c. Akses di View: Untuk menggunakan controller di halaman mana pun, panggil Get.find():

  ```dart
  final CartController cartController = Get.find<CartController>();
  ```

### 2. Variabel & Properti Penting
Akses variabel ini dari View melalui instance controller yang sudah Anda dapatkan.

* RxList<CartItem> cartItems: (Observable) Ini adalah daftar inti yang menyimpan semua item makanan yang ada di keranjang beserta       jumlahnya.

* double get totalPrice: (Properti Reaktif) Secara otomatis menghitung total harga dari semua item di keranjang. Nilainya akan selalu ter-update setiap kali cartItems berubah.

* int get totalItems: (Properti Reaktif) Secara otomatis menghitung jumlah total dari semua item di keranjang (misalnya, 2 porsi Nasi Goreng + 1 porsi Sate = 3 item).

### 3. Daftar Method Siap Pakai

* addItem(Food food)
**Fungsi**: Menambahkan satu porsi makanan ke keranjang. Jika makanan tersebut sudah ada, maka hanya jumlahnya (quantity) yang akan ditambah satu.
**Cara Pakai**: Panggil dari tombol "Tambah" atau "+" pada setiap item makanan.

* removeItem(Food food)
**Fungsi**: Mengurangi satu porsi makanan dari keranjang. Jika jumlahnya lebih dari satu, maka hanya quantity-nya yang dikurangi. Jika jumlahnya sisa satu, maka item tersebut akan dihapus sepenuhnya dari keranjang.
**Cara Pakai**: Panggil dari tombol "Kurang" atau "-" di halaman keranjang.

* clearCart()
**Fungsi**: Menghapus semua item dari keranjang.
**Cara Pakai**: Panggil dari tombol "Kosongkan Keranjang".

### 4. Contoh Penggunaan di View

// Contoh widget untuk ikon keranjang di AppBar

class CartIconBadge extends StatelessWidget {
  const CartIconBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil instance CartController
    final CartController cartController = Get.find<CartController>();

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      // 2. Bungkus dengan Obx agar UI otomatis update
      child: Obx(() {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Ikon keranjang
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // Aksi saat ditekan, misal navigasi ke halaman keranjang
                // atau menampilkan total harga
                Get.snackbar(
                  'Total Belanja',
                  'Rp${cartController.totalPrice.toStringAsFixed(0)}',
                  snackPosition: SnackPosition.TOP,
                );
              },
            ),
            // Badge (lingkaran merah) yang menampilkan jumlah item
            if (cartController.totalItems > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    // 3. Gunakan properti reaktif totalItems
                    cartController.totalItems.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

// Cara pakainya di dalam Scaffold:
//
// Scaffold(
//   appBar: AppBar(
//     title: Text("Menu"),
//     actions: [
//       CartIconBadge(),
//     ],
//   ),
//   // ...
// );
