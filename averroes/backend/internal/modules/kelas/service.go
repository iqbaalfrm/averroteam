package kelas

import (
    "errors"
    "strings"

    "gorm.io/gorm"

    "averroes/internal/database"
)

type Service struct {
    db *gorm.DB
}

func NewService(db *gorm.DB) *Service {
    return &Service{db: db}
}

func (s *Service) List() ([]database.Kelas, error) {
    var items []database.Kelas
    if err := s.db.Order("id desc").Find(&items).Error; err != nil {
        return nil, err
    }
    return items, nil
}

func (s *Service) GetByID(id uint) (database.Kelas, error) {
    var item database.Kelas
    if err := s.db.First(&item, id).Error; err != nil {
        return database.Kelas{}, err
    }
    return item, nil
}

func (s *Service) Create(input CreateRequest) (database.Kelas, error) {
    if err := validateInput(input); err != nil {
        return database.Kelas{}, err
    }

    item := database.Kelas{
        Judul:     strings.TrimSpace(input.Judul),
        Deskripsi: strings.TrimSpace(input.Deskripsi),
    }

    if err := s.db.Create(&item).Error; err != nil {
        return database.Kelas{}, err
    }

    return item, nil
}

func (s *Service) Update(id uint, input UpdateRequest) (database.Kelas, error) {
    if err := validateInput(CreateRequest{Judul: input.Judul, Deskripsi: input.Deskripsi}); err != nil {
        return database.Kelas{}, err
    }

    item, err := s.GetByID(id)
    if err != nil {
        return database.Kelas{}, err
    }

    item.Judul = strings.TrimSpace(input.Judul)
    item.Deskripsi = strings.TrimSpace(input.Deskripsi)

    if err := s.db.Save(&item).Error; err != nil {
        return database.Kelas{}, err
    }

    return item, nil
}

func (s *Service) Delete(id uint) error {
    return s.db.Delete(&database.Kelas{}, id).Error
}

func validateInput(input CreateRequest) error {
    if strings.TrimSpace(input.Judul) == "" {
        return errors.New("judul wajib diisi")
    }
    return nil
}