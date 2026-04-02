# EA Trading MetaTrader 5 - Siap Pakai

## 📱 Deskripsi

Expert Advisor (EA) trading otomatis untuk **MetaTrader 5** menggunakan strategi **Moving Average Crossover**. EA ini dirancang untuk memudahkan trader pemula melakukan trading otomatis di MT5 Android maupun Desktop tanpa perlu coding.

---

## ✨ Fitur

- ✅ **Strategi MA Crossover** – Sinyal beli/jual berdasarkan persilangan dua Moving Average
- ✅ **Manajemen Posisi Otomatis** – Buka dan tutup order secara otomatis
- ✅ **Proteksi 1 Posisi** – Hanya membuka 1 posisi aktif per waktu untuk menghindari overtrading
- ✅ **Stop Loss & Take Profit Otomatis** – Melindungi modal secara otomatis
- ✅ **Trailing Stop** – Mengunci profit saat harga bergerak menguntungkan
- ✅ **Info Panel di Chart** – Menampilkan balance, equity, profit/loss, dan jumlah posisi
- ✅ **Alert & Notifikasi** – Memberikan notifikasi saat posisi dibuka atau ditutup
- ✅ **Money Management** – Validasi lot size sesuai batasan broker
- ✅ **Error Handling** – Penanganan error yang informatif
- ✅ **Comment Order** – Setiap order diberi komentar untuk memudahkan tracking

---

## 📋 Cara Install dan Gunakan

### A. Install di MT5 Android

1. **Download file EA**
   - Download file `MT5_EA_Trading.mq5` dari repository ini

2. **Salin file ke folder MQL5**
   - Buka **MetaTrader 5** di Android
   - Tap menu **≡** (tiga garis) → **Settings** → **Files**
   - Salin file `MT5_EA_Trading.mq5` ke folder:
     ```
     /sdcard/MetaTrader 5/MQL5/Experts/
     ```
   - Alternatif: gunakan aplikasi **file manager** untuk menyalin

3. **Kompilasi EA**
   - Di MT5 Android, kompilasi dilakukan secara **otomatis** saat file .mq5 dideteksi, **atau**
   - Gunakan **MetaEditor** di PC/laptop untuk kompilasi (menghasilkan file `.ex5`)
   - Salin file `.ex5` hasil kompilasi ke folder yang sama

4. **Attach EA ke Chart**
   - Buka chart symbol yang diinginkan (misal XAUUSD, EURUSD)
   - Tap lama pada chart → pilih **Expert Advisors**
   - Pilih `MT5_EA_Trading` dari daftar
   - Sesuaikan parameter sesuai kebutuhan
   - Tap **OK** untuk mengaktifkan EA

5. **Aktifkan Auto Trading**
   - Pastikan tombol **Auto Trading** di MT5 sudah **ON** (berwarna hijau)

---

### B. Install di MT5 Desktop/PC

1. **Buka MetaEditor**
   - Di MT5 Desktop, klik menu **Tools** → **MetaQuotes Language Editor** (F4)

2. **Buka atau Buat File EA**
   - Di MetaEditor, klik **File** → **Open**
   - Navigasi ke folder: `[MT5 Installation Path]\MQL5\Experts\`
   - Salin file `MT5_EA_Trading.mq5` ke folder tersebut
   - Buka file tersebut di MetaEditor

3. **Kompilasi EA**
   - Tekan **F7** atau klik tombol **Compile**
   - Pastikan tidak ada error di tab **Errors** (hanya warning yang diperbolehkan)
   - File `.ex5` akan dibuat secara otomatis

4. **Attach EA ke Chart**
   - Kembali ke MT5 Desktop
   - Buka chart symbol yang diinginkan
   - Di panel **Navigator** (Ctrl+N), cari `MT5_EA_Trading` di folder **Expert Advisors**
   - Drag & drop ke chart, atau klik dua kali
   - Pada tab **Inputs**, sesuaikan parameter
   - Klik **OK**

5. **Aktifkan Auto Trading**
   - Klik tombol **Auto Trading** di toolbar (atau tekan Alt+T)
   - Pastikan ikon berubah menjadi **hijau**

---

## ⚙️ Setting Parameter

| Parameter | Default | Keterangan | Rekomendasi |
|-----------|---------|------------|-------------|
| `LotSize` | 0.01 | Ukuran lot per order | Pemula: 0.01; Intermediate: 0.05–0.1 |
| `StopLoss` | 50 | Stop loss dalam pips | 30–80 pips tergantung volatilitas |
| `TakeProfit` | 100 | Take profit dalam pips | 2× nilai StopLoss |
| `MagicNumber` | 123456 | ID unik untuk order EA ini | Ubah jika menggunakan beberapa EA |
| `FastMA` | 10 | Period MA cepat | 5–20 |
| `SlowMA` | 50 | Period MA lambat | 20–200 |
| `Timeframe` | PERIOD_H1 | Timeframe analisis | H1 atau H4 untuk pemula |
| `Slippage` | 10 | Maksimal slippage | 5–20 pips |
| `UseTrailingStop` | true | Aktifkan trailing stop | Disarankan true |
| `TrailingStop` | 30 | Jarak trailing stop (pips) | 20–50 pips |
| `TrailingStep` | 5 | Langkah geser trailing stop | 3–10 pips |

---

## 📊 Strategi Trading

### Moving Average Crossover

Strategi ini menggunakan **dua buah Exponential Moving Average (EMA)**:

- **MA Cepat (Fast MA)** – Periode pendek (default 10), responsif terhadap pergerakan harga
- **MA Lambat (Slow MA)** – Periode panjang (default 50), menunjukkan tren utama

#### Sinyal Trading

| Sinyal | Kondisi | Aksi |
|--------|---------|------|
| **BUY** 📈 | MA Cepat memotong MA Lambat dari bawah ke atas (*Golden Cross*) | Buka posisi BUY |
| **SELL** 📉 | MA Cepat memotong MA Lambat dari atas ke bawah (*Death Cross*) | Buka posisi SELL |

#### Cara Kerja

```
Harga
  │      ╭─────── MA Cepat (10)
  │  ╭───╯        
  │──╯             ← SELL Signal
  │   ╲
  │    ╲──── MA Lambat (50)
  │     
  │──── MA Lambat (50)
  │  ╮
  │   ╲──── MA Cepat (10)
  │    ╲   ← BUY Signal
  └─────────────────── Waktu
```

- EA hanya membuka **1 posisi aktif** pada satu waktu
- Posisi lama otomatis dikelola dengan SL, TP, dan Trailing Stop
- EA mengecek sinyal **setiap tick** (setiap perubahan harga)

---

## ⚠️ Peringatan dan Tips

> ⚠️ **PENTING: Selalu gunakan akun DEMO terlebih dahulu sebelum trading dengan uang nyata!**

### Tips Keamanan

1. **Mulai dengan akun demo** – Test EA minimal 2–4 minggu di akun demo sebelum live
2. **Gunakan lot kecil** – Mulai dengan LotSize 0.01 untuk meminimalkan risiko
3. **Atur Stop Loss selalu** – Jangan pernah trading tanpa Stop Loss
4. **Monitor secara rutin** – Cek performa EA setidaknya sekali sehari
5. **Hindari berita besar** – Nonaktifkan EA saat ada rilis berita fundamental penting (NFP, suku bunga, dll.)
6. **Backup konfigurasi** – Simpan file `.set` parameter yang sudah dioptimalkan

### Tips Performa

- **Timeframe H1 atau H4** lebih stabil daripada M1/M5 untuk strategi MA
- **Pair yang disarankan**: EURUSD, GBPUSD, XAUUSD
- **Waktu trading terbaik**: Sesi London (07.00–16.00 GMT) dan New York (12.00–21.00 GMT)
- Hindari trading saat market tutup (Sabtu–Minggu)

---

## 🔧 Troubleshooting

### EA tidak bisa dikompilasi
- Pastikan menggunakan **MetaEditor versi MT5** (bukan MT4)
- Periksa apakah ada file `Trade.mqh` dan `PositionInfo.mqh` di folder `Include\Trade\`
- Update MetaTrader 5 ke versi terbaru

### EA tidak membuka order
- Pastikan tombol **Auto Trading** sudah **ON** (hijau)
- Periksa apakah ada **log error** di tab Experts (Ctrl+T)
- Pastikan koneksi internet stabil
- Periksa apakah akun memiliki **dana yang cukup** untuk margin

### Trailing Stop tidak bergerak
- Posisi harus sudah **profit minimal sebesar nilai TrailingStop** sebelum trailing aktif
- Pastikan `UseTrailingStop = true`

### Info Panel tidak muncul
- Aktifkan **Allow DLL imports** di pengaturan EA
- Pastikan chart tidak dalam mode read-only

### Error "Invalid lot size"
- Kurangi nilai `LotSize` (coba 0.01)
- Cek minimum lot yang diizinkan broker Anda

### EA berjalan tapi tidak ada sinyal
- Tunggu minimal 50 candle agar data MA cukup terkumpul
- Coba ganti timeframe ke H1 atau H4
- Pastikan symbol yang digunakan memiliki data historis yang cukup

---

## 📞 Support

Jika mengalami masalah atau memiliki pertanyaan:

- 🐛 **Laporkan bug**: [GitHub Issues](https://github.com/kridho50/rst_miniProject/issues)
- 📖 **Dokumentasi**: Baca file `INSTALL_GUIDE.md` untuk panduan instalasi lengkap
- ⚙️ **Parameter preset**: Gunakan file `MT5_EA_Trading.set` untuk setting yang sudah dioptimalkan

---

## ⚖️ Disclaimer

> Trading forex dan instrumen keuangan lainnya mengandung **risiko tinggi**. EA ini disediakan untuk tujuan edukasi dan tidak menjamin keuntungan. Selalu lakukan riset mandiri dan pertimbangkan toleransi risiko Anda sebelum trading dengan uang nyata.
