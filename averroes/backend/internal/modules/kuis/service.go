package kuis

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

func (s *Service) List(kelasID uint) ([]database.Kuis, error) {
    var items []database.Kuis
    tx := s.db.Model(&database.Kuis{})
    if kelasID > 0 {
        tx = tx.Where("kelas_id = ?", kelasID)
    }

    if err := tx.Order("kelas_id asc, id asc").Find(&items).Error; err != nil {
        return nil, err
    }

    return items, nil
}

func (s *Service) GetByID(id uint) (database.Kuis, error) {
    var item database.Kuis
    if err := s.db.First(&item, id).Error; err != nil {
        return database.Kuis{}, err
    }
    return item, nil
}

func (s *Service) Create(input CreateRequest) (database.Kuis, error) {
    if err := validateInput(input); err != nil {
        return database.Kuis{}, err
    }

    item := database.Kuis{
        KelasID:    input.KelasID,
        Pertanyaan: strings.TrimSpace(input.Pertanyaan),
    }

    if err := s.db.Create(&item).Error; err != nil {
        return database.Kuis{}, err
    }

    return item, nil
}

func (s *Service) Update(id uint, input UpdateRequest) (database.Kuis, error) {
    if err := validateInput(CreateRequest{KelasID: input.KelasID, Pertanyaan: input.Pertanyaan}); err != nil {
        return database.Kuis{}, err
    }

    item, err := s.GetByID(id)
    if err != nil {
        return database.Kuis{}, err
    }

    item.KelasID = input.KelasID
    item.Pertanyaan = strings.TrimSpace(input.Pertanyaan)

    if err := s.db.Save(&item).Error; err != nil {
        return database.Kuis{}, err
    }

    return item, nil
}

func (s *Service) Delete(id uint) error {
    return s.db.Delete(&database.Kuis{}, id).Error
}

func validateInput(input CreateRequest) error {
    if input.KelasID == 0 {
        return errors.New("kelas_id wajib diisi")
    }
    if strings.TrimSpace(input.Pertanyaan) == "" {
        return errors.New("pertanyaan wajib diisi")
    }
    return nil
}