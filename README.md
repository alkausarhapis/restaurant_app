# Restaurant App 🍽️

Aplikasi Flutter untuk menampilkan daftar restoran, detail restoran, pencarian, dan fitur ulasan dengan data dari [Restaurant API Dicoding](https://restaurant-api.dicoding.dev/).

## ✨ Features

### **Daftar Restoran 📃**

- Menampilkan list restoran dari API.
- Informasi utama: nama, gambar, kota, dan rating.
- Indikator loading saat fetch data.

### **Detail Restoran 🍽️**

- Menampilkan detail lengkap: nama, gambar, deskripsi, kota, alamat, rating, kategori, menu makanan, menu minuman, serta review pelanggan.
- Tombol untuk menambahkan ulasan baru.

### **Pencarian Restoran 🔍**

- Halaman pencarian dengan TextField.
- Menampilkan hasil pencarian restoran dari API berdasarkan keyword.

### **Tambah Review 👍**

- Form untuk menambahkan ulasan dengan field nama dan review.
- Review baru dikirim ke API dan langsung tampil di halaman detail.

### **Error Handling ⛔**

- Menampilkan pesan error atau tampilan “No Internet” saat gagal memuat data.
- Pesan mudah dipahami dan disertai tombol refresh.

### **Hero Animation 🎪**

- Efek transisi Hero antara halaman daftar → detail (gambar, teks, atau widget).

### **Tema 🎨**

- Mendukung tema terang & gelap.
- Menggunakan warna kustom dan font berbeda dari default Flutter.
- Toggle tema tersedia di aplikasi.

### **State Management 📂**

- Menggunakan **Provider**.
- State API dikelola dengan sealed class (`Loading`, `Loaded`, `Error`, `NoInternet`, dll).

## 📌 Notes for Reviewer

### Semua kriteria telah diimplementasikan:

- Daftar & detail restoran dari API ✅
- Pencarian restoran ✅
- Tambah review restoran ✅
- Animasi Hero ✅
- Tema terang & gelap + custom font/color ✅
- Error handling & indikator loading ✅
- State management dengan Provider & sealed class ✅
