# 📊 KNN Process — Soybean Yield Prediction

Dokumen ini menjelaskan secara lengkap proses perhitungan **K-Nearest Neighbors (KNN)** yang digunakan dalam aplikasi prediksi hasil panen kedelai, berdasarkan implementasi di `runKNN()`.

---

## 🌱 Variabel Input

| Variabel | Satuan | Keterangan |
|---|---|---|
| `suhu` | °C | Suhu udara rata-rata |
| `curah_hujan` | mm | Curah hujan |
| `kelembaban` | % | Kelembaban udara |
| `ph_tanah` | - | Tingkat keasaman tanah |
| `nitrogen` | mg/kg | Kandungan nitrogen tanah |
| `fosfor` | mg/kg | Kandungan fosfor tanah |
| `kalium` | mg/kg | Kandungan kalium tanah |

**Variabel Target (Output):** `hasil_panen` (ton/ha)

---

## ⚙️ Parameter Algoritma

| Parameter | Nilai |
|---|---|
| K (jumlah tetangga) | **20** |
| Metode normalisasi | **Min-Max Normalization** |
| Metode jarak | **Euclidean Distance** |
| Metode agregasi | **Rata-rata (Mean)** |

---

## 🔄 Alur Proses KNN (Step-by-Step)

### Step 1 — Hitung Min & Max Setiap Fitur dari Dataset

Sebelum normalisasi, sistem melakukan iterasi ke seluruh data pada collection `dataset_soybean` untuk mencari nilai **minimum** dan **maksimum** dari setiap fitur/variabel.

Nilai ini digunakan sebagai parameter normalisasi pada langkah berikutnya.

```
Untuk setiap record d di dataset:
  minSuhu  = min(minSuhu, d.suhu)
  maxSuhu  = max(maxSuhu, d.suhu)
  minCurahHujan = min(minCurahHujan, d.curahHujan)
  maxCurahHujan = max(maxCurahHujan, d.curahHujan)
  ... (begitu seterusnya untuk semua 7 fitur)
```

---

### Step 2 — Normalisasi Input dengan Min-Max

Setelah min & max diketahui, nilai input dari pengguna dinormalisasi menggunakan rumus **Min-Max Normalization**:

$$x\_norm = \frac{x - min}{max - min}$$

> Jika `max - min = 0` (semua nilai fitur di dataset sama), maka hasil normalisasi adalah `0.0` untuk menghindari pembagian dengan nol.

**Contoh** (misalnya untuk fitur `suhu`):

```
Diketahui: suhu_input = 28.5, minSuhu = 20.0, maxSuhu = 35.0

suhu_norm = (28.5 - 20.0) / (35.0 - 20.0)
          = 8.5 / 15.0
          = 0.5667
```

Proses ini dilakukan untuk **semua 7 fitur** pada data input pengguna, menghasilkan `normInput`:

```dart
normInput = {
  'suhu':        norm(suhu,        minSuhu,        maxSuhu),
  'curah_hujan': norm(curahHujan,  minCurahHujan,  maxCurahHujan),
  'kelembaban':  norm(kelembaban,  minKelembaban,  maxKelembaban),
  'ph_tanah':    norm(phTanah,     minPhTanah,     maxPhTanah),
  'nitrogen':    norm(nitrogen,    minNitrogen,     maxNitrogen),
  'fosfor':      norm(fosfor,      minFosfor,       maxFosfor),
  'kalium':      norm(kalium,      minKalium,       maxKalium),
}
```

---

### Step 3 — Hitung Jarak Euclidean ke Seluruh Dataset

Untuk setiap record `d` di dataset, nilai fiturnya juga dinormalisasi terlebih dahulu menggunakan min & max yang sama dari Step 1, kemudian dihitung **jarak Euclidean** antara data input pengguna (yang sudah dinormalisasi) dengan record tersebut.

**Rumus Euclidean Distance (7 dimensi):**

$$dist = \sqrt{\sum_{i=1}^{7} (x\_norm_i - d\_norm_i)^2}$$

Secara eksplisit:

```
dist = sqrt(
  (normInput.suhu        - norm(d.suhu))²        +
  (normInput.curah_hujan - norm(d.curahHujan))²  +
  (normInput.kelembaban  - norm(d.kelembaban))²   +
  (normInput.ph_tanah    - norm(d.phTanah))²      +
  (normInput.nitrogen    - norm(d.nitrogen))²     +
  (normInput.fosfor      - norm(d.fosfor))²       +
  (normInput.kalium      - norm(d.kalium))²
)
```

Hasil dari step ini adalah sebuah list berisi pasangan `{ distance, hasilPanen }` untuk setiap record di dataset.

---

### Step 4 — Urutkan Berdasarkan Jarak Terkecil

List hasil perhitungan jarak diurutkan secara **ascending** (dari jarak terkecil ke terbesar), sehingga record yang paling "mirip" dengan input pengguna berada di urutan paling atas.

```
distances.sort((a, b) => a.distance.compareTo(b.distance))
```

---

### Step 5 — Ambil K = 20 Tetangga Terdekat

Dari list yang sudah diurutkan, diambil **20 record pertama** (indeks 0–19) sebagai tetangga terdekat (`kNeighbors`).

```
kNeighbors = distances.take(20)
```

---

### Step 6 — Hitung Rata-rata Hasil Panen

Nilai `hasil_panen` dari 20 tetangga terdekat dirata-ratakan untuk menghasilkan **estimasi hasil panen** (prediksi).

$$\hat{y} = \frac{1}{K} \sum_{i=1}^{K} hasilPanen_i = \frac{\sum_{i=1}^{20} hasilPanen_i}{20}$$

```dart
avgHasilPanen = kNeighbors.map((n) => n.hasilPanen).sum / kNeighbors.length
```

---

## 📦 Output Fungsi `runKNN()`

Fungsi mengembalikan `Map<String, dynamic>` berisi:

| Key | Tipe | Isi |
|---|---|---|
| `result` | `double` | Estimasi hasil panen (ton/ha) |
| `normalized_input` | `Map<String, double>` | Nilai normalisasi dari setiap fitur input pengguna |
| `neighbors` | `List<Map>` | List 20 tetangga terdekat, masing-masing berisi `distance` dan `hasil_panen` |

Seluruh output ini disimpan ke Firestore collection `soybean_prediction` bersama data input asli, data pengguna, dan timestamp prediksi.

---

## 💾 Penyimpanan ke Firestore (`soybean_prediction`)

Setelah prediksi selesai, data yang disimpan meliputi:

- Semua nilai input asli (suhu, curah_hujan, kelembaban, ph_tanah, nitrogen, fosfor, kalium)
- `result` — estimasi hasil panen
- `normalized_input` — hasil normalisasi input
- `neighbors` — 20 tetangga terdekat (jarak + hasil panen masing-masing)
- `k` — nilai K yang digunakan (20)
- `uid` & `username` — data pengguna yang melakukan prediksi
- `date` — timestamp prediksi
- `actual_yield` — diinisialisasi `null`, dapat diisi pengguna di kemudian hari

---

## 📌 Catatan Penting

- Normalisasi dilakukan **ulang setiap kali prediksi dijalankan** menggunakan min/max dari dataset terkini di Firestore, sehingga hasil prediksi selalu mencerminkan kondisi dataset yang paling up-to-date.
- Nilai K = **20** telah ditentukan berdasarkan riset/eksperimen terhadap dataset yang ada dan bersifat konstan (hardcoded sebagai `_k = 20`).
- Jika dataset kosong atau jumlah data kurang dari 20, prediksi tetap berjalan dengan mengambil seluruh data yang tersedia sebagai tetangga.
