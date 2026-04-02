# Panduan Instalasi EA Trading MT5 - Step by Step

## 🔰 Persiapan Awal

Sebelum memulai, pastikan Anda sudah memiliki:
- [ ] Aplikasi **MetaTrader 5** sudah terinstall (Android atau PC/Desktop)
- [ ] Akun trading MT5 (akun **demo** disarankan untuk pemula)
- [ ] File `MT5_EA_Trading.mq5` dan `MT5_EA_Trading.set` sudah didownload

---

## 📱 Instalasi di Android

### Langkah 1 – Download File EA
1. Buka browser di Android Anda
2. Kunjungi halaman repository: `https://github.com/kridho50/rst_miniProject`
3. Tap file `MT5_EA_Trading.mq5`
4. Tap tombol **Download** (ikon unduhan) untuk menyimpan file
5. Ulangi untuk file `MT5_EA_Trading.set`

### Langkah 2 – Salin File ke Folder MT5
1. Buka aplikasi **File Manager** di Android Anda
2. Navigasi ke:
   ```
   Internal Storage → MetaTrader 5 → MQL5 → Experts
   ```
   > 💡 **Catatan**: Jika folder tidak ditemukan, buka MT5 terlebih dahulu agar folder dibuat otomatis
3. Salin file `MT5_EA_Trading.mq5` ke folder `Experts`
4. Salin file `MT5_EA_Trading.set` ke folder yang sama

### Langkah 3 – Muat Ulang MT5
1. Tutup aplikasi MT5 sepenuhnya
2. Buka kembali MT5
3. MT5 akan mendeteksi dan mengkompilasi file EA secara otomatis

### Langkah 4 – Buka Chart
1. Di MT5 Android, tap **Pasar** atau **Quotes**
2. Pilih symbol yang ingin Anda trading (contoh: XAUUSD, EURUSD)
3. Tap ikon **Chart** untuk membuka chart

### Langkah 5 – Pasang EA ke Chart
1. Di halaman chart, tap ikon **f(x)** atau menu **Analitik**
2. Pilih **Expert Advisors**
3. Tap tombol **+** atau **Tambah**
4. Pilih `MT5_EA_Trading` dari daftar
5. Tap **Muat Pengaturan** → pilih file `MT5_EA_Trading.set`
6. Periksa parameter, lalu tap **OK**

### Langkah 6 – Aktifkan Auto Trading
1. Tap ikon **Auto Trading** (ikon robot/play) di toolbar
2. Pastikan statusnya **AKTIF** (berwarna hijau atau ada indikator aktif)
3. EA akan mulai memantau pasar dan membuka posisi sesuai sinyal

---

## 💻 Instalasi di PC/Desktop

### Langkah 1 – Download File EA
1. Kunjungi: `https://github.com/kridho50/rst_miniProject`
2. Klik file `MT5_EA_Trading.mq5`
3. Klik tombol **Raw**, lalu tekan `Ctrl+S` untuk menyimpan
4. Atau klik kanan → **Save link as...**
5. Ulangi untuk `MT5_EA_Trading.set`

### Langkah 2 – Temukan Folder MQL5
1. Buka **MetaTrader 5** di PC Anda
2. Klik menu **File** → **Open Data Folder**
3. Navigasi ke folder:
   ```
   [Data Folder]\MQL5\Experts\
   ```
4. Salin file `MT5_EA_Trading.mq5` ke folder `Experts`

### Langkah 3 – Kompilasi dengan MetaEditor
1. Di MT5, tekan **F4** atau klik **Tools** → **MetaQuotes Language Editor**
2. Di MetaEditor, klik **File** → **Open**
3. Navigasi ke folder `Experts` dan buka `MT5_EA_Trading.mq5`
4. Tekan **F7** atau klik tombol **Compile** (ikon palu)
5. Periksa tab **Errors** – pastikan tidak ada **error** (warning adalah normal)
6. Jika berhasil, file `MT5_EA_Trading.ex5` akan muncul di folder `Experts`

### Langkah 4 – Attach EA ke Chart
1. Kembali ke MT5 Desktop
2. Buka chart symbol yang diinginkan (klik dua kali di Market Watch)
3. Di panel **Navigator** kiri (Ctrl+N), expand folder **Expert Advisors**
4. Temukan `MT5_EA_Trading`
5. **Drag & drop** ke chart, ATAU klik dua kali namanya

### Langkah 5 – Konfigurasi Parameter
1. Dialog pengaturan EA akan muncul
2. Pada tab **Common**:
   - ✅ Centang **Allow live trading**
   - ✅ Centang **Allow DLL imports** (jika diperlukan)
3. Pada tab **Inputs**:
   - Klik **Load** → pilih file `MT5_EA_Trading.set` untuk memuat preset
   - Atau atur parameter secara manual sesuai kebutuhan
4. Klik **OK** untuk menerapkan

### Langkah 6 – Aktifkan Auto Trading
1. Klik tombol **Auto Trading** di toolbar (atau tekan **Alt+T**)
2. Ikon berubah menjadi **hijau** = EA aktif
3. Cek tab **Experts** (Ctrl+T) untuk melihat log aktivitas EA

---

## ✅ Verifikasi EA Berjalan

Setelah EA terpasang, verifikasi sebagai berikut:

| Indikator | Kondisi Normal |
|-----------|----------------|
| Ikon smiley di sudut chart | 😊 (tersenyum) = EA aktif |
| Tab Experts | Tampil log "EA Trading berhasil diinisialisasi" |
| Info panel di chart | Muncul panel dengan info Balance, Equity, dll. |
| Auto Trading | Status ON / hijau |

---

## 🔄 Update EA

Jika ada versi baru EA:
1. Download file `.mq5` terbaru dari repository
2. Hapus EA dari chart (klik kanan chart → **Expert Advisors** → **Remove**)
3. Salin file baru ke folder `Experts` (timpa file lama)
4. Kompilasi ulang (F7 di MetaEditor)
5. Pasang kembali EA ke chart

---

## ❓ FAQ (Pertanyaan Umum)

**Q: Apakah EA ini gratis?**
A: Ya, EA ini open source dan gratis digunakan.

**Q: Apakah EA bisa digunakan di MT4?**
A: Tidak, EA ini dibuat khusus untuk MetaTrader 5 (MQL5).

**Q: Berapa modal minimum yang dibutuhkan?**
A: Dengan LotSize 0.01, modal minimum sekitar $10–$50 untuk akun micro/cent. Selalu gunakan akun demo terlebih dahulu.

**Q: Apakah EA bisa dijalankan di beberapa symbol sekaligus?**
A: Ya, pasang EA di chart yang berbeda dengan MagicNumber yang berbeda untuk setiap instance.

**Q: EA tidak muncul di daftar Expert Advisors**
A: Pastikan file sudah dikompilasi tanpa error dan berada di folder `MQL5\Experts\` yang benar.

---

## 📞 Bantuan Lebih Lanjut

- 📖 Baca `README_MT5_EA.md` untuk penjelasan strategi dan parameter lengkap
- 🐛 Laporkan masalah di [GitHub Issues](https://github.com/kridho50/rst_miniProject/issues)
