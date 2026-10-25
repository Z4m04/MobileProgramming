Nama: Ahmad Zamroni
NIM: 240605110216
Kelas: Mobile Programming

# Bandography

Bandography adalah aplikasi Flutter untuk mencari band, melihat diskografi, dan membuka track list album melalui MusicBrainz API.

## Fitur

- Pencarian band atau musisi
- Diskografi album, EP, dan single
- Detail rilisan dan track list
- State loading, data kosong, dan error API

## Teknologi

- Flutter dan Dart
- HttpClient bawaan Dart
- MusicBrainz Web Service API

## Menjalankan aplikasi

```bash
flutter pub get
flutter run
```

Perangkat membutuhkan koneksi internet. MusicBrainz membatasi aplikasi menjadi satu permintaan API per detik; aplikasi menerapkan jeda otomatis.
