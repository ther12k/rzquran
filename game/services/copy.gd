extends RefCounted
## Indonesian interface copy (single source for scenes), from
## docs/godot-mvp/design/tokens-and-copy.md. Copy is plain text rendered in
## Labels — never interpolated into code paths. Forbidden phrasing ("hafal",
## "mahir", "sudah lancar") is absent by construction.

const HOME_GREETING := "Halo, %s!"
const HOME_SUBTITLE := "Yuk, belajar sebentar."
const FIXTURE_TITLE := "Latihan Simulasi"
const FIXTURE_BANNER := "SIMULASI — BUKAN MATERI BELAJAR"
const ACTION_START := "Mulai belajar"
const ACTION_RESUME := "Lanjutkan"
const ACTION_HOME := "Kembali ke beranda"
const ACTION_EXIT := "Keluar"
const ACTION_RETRY := "Coba sambungkan lagi"
const LOAD_WAIT := "Sedang menyiapkan latihan…"
const NETWORK_WAIT := "Koneksi terputus. Jawabanmu belum terkonfirmasi."
const CONTENT_UNAVAILABLE := "Materi ini belum tersedia."
const CONTENT_RECALLED := "Materi ini sedang diperiksa. Pilih kegiatan lain."
const SESSION_EXPIRED := "Sesi ini sudah berakhir. Yuk, mulai lagi."
const VERSION_UNSUPPORTED := "Aplikasi tidak cocok dengan server. Perbarui aplikasi."
const EXIT_UNFINISHED_NOTE := "Sesi yang belum selesai tidak dihitung sebagai latihan."
const PAIRING_TITLE := "Minta bantuan orang tua"
const PAIRING_HINT := "Minta orang tua membuka situs dan memasukkan kode ini."
const PAIRING_EXPIRES := "Kode ini berlaku selama 5 menit."
const PAIRING_WAIT := "Menunggu persetujuan orang tua…"
const PAIRING_DENIED := "Penautan ditolak. Coba lagi."
const PAIRING_EXPIRED_CODE := "Kode penautan kedaluwarsa. Coba lagi."

## Contract version this build speaks; anything else refuses to render
## learning content (godot-structure.md: reject incompatible versions).
const CONTRACT_VERSION := "1"
