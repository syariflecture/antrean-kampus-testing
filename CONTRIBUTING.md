# Cara Berkontribusi pada antrean-kampus

Dokumen ini adalah kesepakatan kerja tim. Setiap anggota wajib mengikutinya.

## Strategi percabangan: GitHub Flow

1. Cabang `main` selalu dalam keadaan dapat dijalankan.
2. Setiap pekerjaan dimulai dari cabang baru yang diambil dari `main` terbaru.
3. Cabang kerja berumur pendek: selesaikan dalam hitungan hari, bukan minggu.
4. Perubahan masuk ke `main` hanya lewat pull request yang sudah diulas
   (mulai Pertemuan 5). Tidak ada yang mendorong langsung ke `main`.
5. Cabang yang sudah digabungkan dihapus.

## Nama cabang

Format: `<tipe>/<deskripsi-singkat>`, huruf kecil, kata dipisah tanda hubung.

| Tipe | Dipakai untuk | Contoh |
|---|---|---|
| feat | fitur baru | feat/form-antrean |
| fix | perbaikan kesalahan | fix/nomor-antrean-ganda |
| docs | dokumentasi | docs/profil-bagas |
| chore | pekerjaan pemeliharaan | chore/perbarui-gitignore |
| refactor | merapikan kode tanpa mengubah perilaku | refactor/pisah-modul-db |
| test | menambah atau memperbaiki pengujian | test/uji-endpoint-antrean |

## Pesan commit: Conventional Commits 1.0.0

```
<tipe>[(lingkup)]: <deskripsi>

[badan pesan, opsional]
```

- Deskripsi ditulis singkat, huruf kecil, tanpa titik di akhir.
- Satu commit berisi satu perubahan yang utuh.
- Tipe yang dipakai tim: feat, fix, docs, style, refactor, perf, test, build, ci, chore.

Contoh: `docs(anggota): lengkapi peran bagas`

## Proteksi cabang main

Cabang `main` dilindungi ruleset GitHub: wajib lewat pull request dengan
minimal satu persetujuan, tidak boleh dihapus, dan tidak boleh di-force push.
