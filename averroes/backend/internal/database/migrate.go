package database

import "gorm.io/gorm"

func AutoMigrate(db *gorm.DB) error {
	return db.AutoMigrate(
		&User{},
		&ScreenerKoin{},
		&Kelas{},
		&Materi{},
		&Kuis{},
		&JawabanKuis{},
		&ProgresKelas{},
		&Portofolio{},
		&KodeOTP{},
	)
}
