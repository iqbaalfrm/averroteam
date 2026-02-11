package auth

import (
	"errors"
	"fmt"
	"math/rand"
	"strings"
	"time"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"

	"averroes/internal/database"
)

type Service struct {
	db *gorm.DB
}

func NewService(db *gorm.DB) *Service {
	return &Service{db: db}
}

func (s *Service) FindOrCreateUserByEmail(email string) (database.User, error) {
	email = strings.TrimSpace(strings.ToLower(email))
	if email == "" {
		return database.User{}, errors.New("email wajib diisi")
	}

	var user database.User
	err := s.db.Where("email = ?", email).First(&user).Error
	if err == nil {
		return user, nil
	}
	if !errors.Is(err, gorm.ErrRecordNotFound) {
		return database.User{}, err
	}

	user = database.User{
		Nama:  "",
		Email: &email,
		Role:  "user",
	}

	if err := s.db.Create(&user).Error; err != nil {
		return database.User{}, err
	}

	return user, nil
}

func (s *Service) CreateGuestUser() (database.User, error) {
	user := database.User{
		Nama:  "",
		Email: nil,
		Role:  "guest",
	}

	if err := s.db.Create(&user).Error; err != nil {
		return database.User{}, err
	}

	return user, nil
}

func (s *Service) FindOrCreateAdmin(email string) (database.User, error) {
	email = strings.TrimSpace(strings.ToLower(email))
	if email == "" {
		return database.User{}, errors.New("email admin wajib diisi")
	}

	var user database.User
	err := s.db.Where("email = ?", email).First(&user).Error
	if err == nil {
		if user.Role != "admin" {
			user.Role = "admin"
			if err := s.db.Save(&user).Error; err != nil {
				return database.User{}, err
			}
		}
		return user, nil
	}
	if !errors.Is(err, gorm.ErrRecordNotFound) {
		return database.User{}, err
	}

	user = database.User{
		Nama:  "",
		Email: &email,
		Role:  "admin",
	}

	if err := s.db.Create(&user).Error; err != nil {
		return database.User{}, err
	}

	return user, nil
}

func (s *Service) RegisterUser(nama string, email string, password string) (database.User, error) {
	nama = strings.TrimSpace(nama)
	email = strings.TrimSpace(strings.ToLower(email))
	password = strings.TrimSpace(password)

	if nama == "" {
		return database.User{}, errors.New("nama wajib diisi")
	}
	if email == "" {
		return database.User{}, errors.New("email wajib diisi")
	}
	if password == "" || len(password) < 8 {
		return database.User{}, errors.New("password minimal 8 karakter")
	}

	var existing database.User
	if err := s.db.Where("email = ?", email).First(&existing).Error; err == nil {
		return database.User{}, errors.New("email sudah terdaftar")
	} else if !errors.Is(err, gorm.ErrRecordNotFound) {
		return database.User{}, err
	}

	hashed, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return database.User{}, err
	}

	hashString := string(hashed)
	user := database.User{
		Nama:         nama,
		Email:        &email,
		PasswordHash: &hashString,
		Role:         "user",
	}

	if err := s.db.Create(&user).Error; err != nil {
		return database.User{}, err
	}

	return user, nil
}

func (s *Service) LoginUser(email string, password string) (database.User, error) {
	email = strings.TrimSpace(strings.ToLower(email))
	password = strings.TrimSpace(password)

	if email == "" {
		return database.User{}, errors.New("email wajib diisi")
	}
	if password == "" {
		return database.User{}, errors.New("password wajib diisi")
	}

	var user database.User
	if err := s.db.Where("email = ?", email).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return database.User{}, errors.New("email atau password salah")
		}
		return database.User{}, err
	}

	if user.PasswordHash == nil || *user.PasswordHash == "" {
		return database.User{}, errors.New("akun ini terdaftar via Google, silakan gunakan login Google")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(*user.PasswordHash), []byte(password)); err != nil {
		return database.User{}, errors.New("email atau password salah")
	}

	return user, nil
}

func (s *Service) GenerateOTP(email string, tipe string) (string, error) {
	email = strings.TrimSpace(strings.ToLower(email))
	if email == "" {
		return "", errors.New("email wajib diisi")
	}

	// Untuk lupa password, pastikan email terdaftar
	if tipe == "lupa_password" {
		var user database.User
		if err := s.db.Where("email = ?", email).First(&user).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return "", errors.New("email tidak terdaftar")
			}
			return "", err
		}
	}

	// Hapus OTP lama yang belum dipakai
	s.db.Where("email = ? AND tipe = ? AND terverifikasi = ?", email, tipe, false).
		Delete(&database.KodeOTP{})

	// Generate kode OTP 6 digit
	kode := fmt.Sprintf("%06d", rand.Intn(1000000))

	otp := database.KodeOTP{
		Email:         email,
		Kode:          kode,
		Tipe:          tipe,
		Terverifikasi: false,
		KadaluarsaAt:  time.Now().Add(5 * time.Minute),
	}

	if err := s.db.Create(&otp).Error; err != nil {
		return "", errors.New("gagal membuat kode OTP")
	}

	return kode, nil
}

func (s *Service) VerifyOTP(email string, kode string, tipe string) error {
	email = strings.TrimSpace(strings.ToLower(email))
	kode = strings.TrimSpace(kode)

	if email == "" || kode == "" {
		return errors.New("email dan kode OTP wajib diisi")
	}

	var otp database.KodeOTP
	err := s.db.Where("email = ? AND kode = ? AND tipe = ? AND terverifikasi = ?",
		email, kode, tipe, false).
		Order("created_at DESC").
		First(&otp).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return errors.New("kode OTP tidak valid")
		}
		return err
	}

	if time.Now().After(otp.KadaluarsaAt) {
		return errors.New("kode OTP sudah kadaluarsa")
	}

	otp.Terverifikasi = true
	s.db.Save(&otp)

	return nil
}

func (s *Service) ResetPassword(email string, kode string, passwordBaru string) error {
	email = strings.TrimSpace(strings.ToLower(email))
	kode = strings.TrimSpace(kode)
	passwordBaru = strings.TrimSpace(passwordBaru)

	if passwordBaru == "" || len(passwordBaru) < 8 {
		return errors.New("password baru minimal 8 karakter")
	}

	// Cek OTP sudah terverifikasi
	var otp database.KodeOTP
	err := s.db.Where("email = ? AND kode = ? AND tipe = ? AND terverifikasi = ?",
		email, kode, "lupa_password", true).
		Order("created_at DESC").
		First(&otp).Error

	if err != nil {
		return errors.New("verifikasi OTP belum dilakukan")
	}

	// Cek kadaluarsa (beri waktu tambahan 10 menit setelah verifikasi)
	if time.Now().After(otp.KadaluarsaAt.Add(10 * time.Minute)) {
		return errors.New("sesi reset password sudah kadaluarsa, silakan ulangi")
	}

	// Hash password baru
	hashed, err := bcrypt.GenerateFromPassword([]byte(passwordBaru), bcrypt.DefaultCost)
	if err != nil {
		return errors.New("gagal memproses password baru")
	}

	hashString := string(hashed)
	result := s.db.Model(&database.User{}).
		Where("email = ?", email).
		Update("password_hash", hashString)

	if result.Error != nil {
		return errors.New("gagal menyimpan password baru")
	}
	if result.RowsAffected == 0 {
		return errors.New("email tidak ditemukan")
	}

	// Hapus semua OTP lupa password untuk email ini
	s.db.Where("email = ? AND tipe = ?", email, "lupa_password").
		Delete(&database.KodeOTP{})

	return nil
}
