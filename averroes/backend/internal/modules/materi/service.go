package materi

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

func (s *Service) List(kelasID uint) ([]database.Materi, error) {
    var items []database.Materi
    tx := s.db.Model(&database.Materi{})
    if kelasID > 0 {
        tx = tx.Where("kelas_id = ?", kelasID)
    }

    if err := tx.Order("kelas_id asc, urutan asc, id asc").Find(&items).Error; err != nil {
        return nil, err
    }

    return items, nil
}

func (s *Service) GetByID(id uint) (database.Materi, error) {
    var item database.Materi
    if err := s.db.First(&item, id).Error; err != nil {
        return database.Materi{}, err
    }
    return item, nil
}

func (s *Service) Create(input CreateRequest) (database.Materi, error) {
    if err := validateInput(input); err != nil {
        return database.Materi{}, err
    }

    item := database.Materi{
        KelasID: input.KelasID,
        Judul:   strings.TrimSpace(input.Judul),
        Konten:  strings.TrimSpace(input.Konten),
        Urutan:  input.Urutan,
    }

    if err := s.db.Create(&item).Error; err != nil {
        return database.Materi{}, err
    }

    return item, nil
}

func (s *Service) Update(id uint, input UpdateRequest) (database.Materi, error) {
    if err := validateInput(CreateRequest{
        KelasID: input.KelasID,
        Judul:   input.Judul,
        Konten:  input.Konten,
        Urutan:  input.Urutan,
    }); err != nil {
        return database.Materi{}, err
    }

    item, err := s.GetByID(id)
    if err != nil {
        return database.Materi{}, err
    }

    item.KelasID = input.KelasID
    item.Judul = strings.TrimSpace(input.Judul)
    item.Konten = strings.TrimSpace(input.Konten)
    item.Urutan = input.Urutan

    if err := s.db.Save(&item).Error; err != nil {
        return database.Materi{}, err
    }

    return item, nil
}

func (s *Service) Delete(id uint) error {
    return s.db.Delete(&database.Materi{}, id).Error
}

func validateInput(input CreateRequest) error {
    if input.KelasID == 0 {
        return errors.New("kelas_id wajib diisi")
    }
    if strings.TrimSpace(input.Judul) == "" {
        return errors.New("judul wajib diisi")
    }
    return nil
}