package database

import "time"

type User struct {
	ID           uint    `gorm:"primaryKey"`
	Nama         string  `gorm:"size:120"`
	Email        *string `gorm:"uniqueIndex;size:191"`
	PasswordHash *string `gorm:"type:text" json:"-"`
	Role         string  `gorm:"size:20"`
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

type ScreenerKoin struct {
	ID             uint   `gorm:"primaryKey"`
	NamaKoin       string `gorm:"size:120"`
	Simbol         string `gorm:"size:20"`
	StatusSyariah  string `gorm:"size:20"`
	PenjelasanFiqh string `gorm:"type:text"`
	ReferensiUlama string `gorm:"type:text"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

type Kelas struct {
	ID        uint   `gorm:"primaryKey"`
	Judul     string `gorm:"size:150"`
	Deskripsi string `gorm:"type:text"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Materi struct {
	ID        uint   `gorm:"primaryKey"`
	KelasID   uint   `gorm:"index"`
	Judul     string `gorm:"size:150"`
	Konten    string `gorm:"type:text"`
	Urutan    int
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Kuis struct {
	ID         uint   `gorm:"primaryKey"`
	KelasID    uint   `gorm:"index"`
	Pertanyaan string `gorm:"type:text"`
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

type JawabanKuis struct {
	ID        uint   `gorm:"primaryKey"`
	KuisID    uint   `gorm:"index"`
	Jawaban   string `gorm:"type:text"`
	Benar     bool
	CreatedAt time.Time
	UpdatedAt time.Time
}

type ProgresKelas struct {
	ID             uint `gorm:"primaryKey"`
	UserID         uint `gorm:"index"`
	KelasID        uint `gorm:"index"`
	MateriTerakhir uint
	StatusKuis     string `gorm:"size:20"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

type Portofolio struct {
	ID        uint   `gorm:"primaryKey"`
	UserID    uint   `gorm:"index"`
	NamaAset  string `gorm:"size:120"`
	Simbol    string `gorm:"size:20"`
	Jumlah    float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type KodeOTP struct {
	ID            uint   `gorm:"primaryKey"`
	Email         string `gorm:"size:191;index"`
	Kode          string `gorm:"size:6"`
	Tipe          string `gorm:"size:30"` // "lupa_password" atau "verifikasi_email"
	Terverifikasi bool   `gorm:"default:false"`
	KadaluarsaAt  time.Time
	CreatedAt     time.Time
	UpdatedAt     time.Time
}
