# Averroes

Averroes adalah aplikasi edukatif tentang **Aset Kripto Syariah** dan **Fiqh Muamalah Digital**.
Fokus pada edukasi yang tenang, bukan ajakan investasi.

## Struktur Monorepo

```
averroes/
├── backend/            ← Go API (Gin + GORM + SQLite)
│   ├── cmd/api/        ← Entry point server
│   ├── internal/       ← Domain logic (modules, config, database)
│   ├── Dockerfile      ← Untuk deploy ke Zeabur
│   ├── go.mod
│   └── go.sum
├── mobile/             ← Flutter mobile app
│   ├── averroes_app/   ← Aplikasi utama
│   └── packages/       ← Shared Flutter packages (core, network, shared_models)
├── docs/               ← Dokumentasi tambahan
├── .gitignore
└── README.md
```

## Menjalankan Backend (Go API)

```bash
cd backend
go run ./cmd/api
```

Server akan berjalan di `http://localhost:8080`.

### Variabel Lingkungan (Opsional)

| Variabel | Default | Keterangan |
|----------|---------|------------|
| `APP_PORT` | `8080` | Port server |
| `DB_PATH` | `averroes.db` | Path database SQLite |
| `JWT_SECRET` | `averroes-secret` | Secret untuk JWT token |
| `ADMIN_EMAIL` | `admin@averroes.local` | Email admin default |
| `ADMIN_PASSWORD` | `admin123` | Password admin default |
| `GIN_MODE` | `debug` | Mode Gin (`debug` / `release`) |

## Menjalankan Mobile App (Flutter)

```bash
cd mobile/averroes_app
flutter pub get
flutter run
```

## Deploy ke Zeabur

1. Push repository ke GitHub
2. Buat project baru di [Zeabur](https://zeabur.com)
3. Hubungkan repository GitHub
4. Set **Root Directory** ke `backend`
5. Zeabur akan otomatis mendeteksi `Dockerfile`
6. Set environment variables yang diperlukan:
   - `JWT_SECRET` — secret yang kuat untuk production
   - `ADMIN_EMAIL` — email admin
   - `ADMIN_PASSWORD` — password admin yang kuat
   - `GIN_MODE` → `release`
7. Deploy!

### API Endpoint Utama

| Method | Endpoint | Keterangan |
|--------|----------|------------|
| `GET` | `/health` | Health check |
| `GET` | `/api/berita` | Berita aset kripto (scraping harian) |
| `GET` | `/api/screener` | Daftar screener koin syariah |
| `GET` | `/api/kelas` | Daftar kelas edukasi |
| `GET` | `/api/materi` | Daftar materi belajar |
| `POST` | `/api/auth/register` | Registrasi akun |
| `POST` | `/api/auth/guest` | Login sebagai tamu |

## Tim

**Averroes Team** — Skripsi Project
